//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToRefresh
//

import UIKit
import Foundation

public protocol RefreshViewAnimator {
     func animateState(_ state: State)
}

// MARK: PullToRefresh

open class PullToRefresh: NSObject {
    
    open var hideDelay: TimeInterval = 0

    let refreshView: UIView
    var action: (() -> ())?
    
    fileprivate let animator: RefreshViewAnimator
    
    // MARK: - ScrollView & Observing

    fileprivate var scrollViewDefaultInsets = UIEdgeInsets.zero
    weak var scrollView: UIScrollView? {
        willSet {
            removeScrollViewObserving()
        }
        didSet {
            if let scrollView = scrollView {
                scrollViewDefaultInsets = scrollView.contentInset
                addScrollViewObserving()
            }
        }
    }
    
    fileprivate func addScrollViewObserving() {
        scrollView?.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &KVOContext)
    }
    
    fileprivate func removeScrollViewObserving() {
        scrollView?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &KVOContext)
    }

    // MARK: - State
    
    var state: State = .inital {
        didSet {
            animator.animateState(state)
            switch state {
            case .loading:
                if let scrollView = scrollView , (oldValue != .loading) {
                    scrollView.contentOffset = previousScrollViewOffset
                    scrollView.bounces = false
                    UIView.animate(withDuration: 0.3, animations: {
                        let insets = self.refreshView.frame.height + self.scrollViewDefaultInsets.top
                        scrollView.contentInset.top = insets
                        
                        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets)
                        }, completion: { finished in
                            scrollView.bounces = true
                    })
                    
                    action?()
                }
            case .finished:
                removeScrollViewObserving()
                UIView.animate(withDuration: 1, delay: hideDelay, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.scrollView?.contentInset = self.scrollViewDefaultInsets
//                    self.scrollView?.contentOffset.y = -self.scrollViewDefaultInsets.top
                }, completion: { finished in
                    self.addScrollViewObserving()
                    self.state = .inital
                })
            default: break
            }
        }
    }
    
    // MARK: - Initialization
    
    public init(refreshView: UIView, animator: RefreshViewAnimator) {
        self.refreshView = refreshView
        self.animator = animator
    }
    
    public override convenience init() {
        let refreshView = DefaultRefreshView()
        self.init(refreshView: refreshView, animator: DefaultViewAnimator(refreshView: refreshView))
    }
    
    deinit {
        removeScrollViewObserving()
    }
    
    // MARK: KVO

    fileprivate var KVOContext = "PullToRefreshKVOContext"
    fileprivate let contentOffsetKeyPath = "contentOffset"
    fileprivate var previousScrollViewOffset: CGPoint = CGPoint.zero
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &KVOContext && keyPath == contentOffsetKeyPath && object as? UIScrollView == scrollView) {
            let offset = previousScrollViewOffset.y + scrollViewDefaultInsets.top
            let refreshViewHeight = refreshView.frame.size.height
            
            switch offset {
            case 0 where (state != .loading): state = .inital
            case -refreshViewHeight...0 where (state != .loading && state != .finished):
                state = .releasing(progress: -offset / refreshViewHeight)
            case -1000...(-refreshViewHeight):
                if state == State.releasing(progress: 1) && scrollView?.isDragging == false {
                    state = .loading
                } else if state != State.loading && state != State.finished {
                    state = .releasing(progress: 1)
                }
            default: break
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
        previousScrollViewOffset.y = scrollView!.contentOffset.y
    }
    
    // MARK: - Start/End Refreshing
    
    func startRefreshing() {
        if self.state != State.inital {
            return
        }
        
        scrollView?.setContentOffset(CGPoint(x: 0, y: -refreshView.frame.height - scrollViewDefaultInsets.top), animated: true)
        let delayTime = DispatchTime.now() + Double(Int64(0.27 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.state = State.loading
            })
    }
    
    func endRefreshing() {
        if state == .loading {
            state = .finished
        }
    }
}

// MARK: - State enumeration

public enum State:Equatable, CustomStringConvertible {
    case inital, loading, finished
    case releasing(progress: CGFloat)
    
    public var description: String {
        switch self {
        case .inital: return "Inital"
        case .releasing(let progress): return "Releasing:\(progress)"
        case .loading: return "Loading"
        case .finished: return "Finished"
        }
    }
}

public func ==(a: State, b: State) -> Bool {
    switch (a, b) {
    case (.inital, .inital): return true
    case (.loading, .loading): return true
    case (.finished, .finished): return true
    case (.releasing, .releasing): return true
    default: return false
    }
}

// MARK: Default PullToRefresh

class DefaultRefreshView: UIView {
    fileprivate(set) var activicyIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 40)
    }
    
    override func layoutSubviews() {
        if (activicyIndicator == nil) {
            activicyIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activicyIndicator.hidesWhenStopped = true
            addSubview(activicyIndicator)
        }
        centerActivityIndicator()
        setupFrameInSuperview(superview)
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupFrameInSuperview(superview)
    }
    
    fileprivate func setupFrameInSuperview(_ newSuperview: UIView?) {
        if let superview = newSuperview {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.frame.width, height: 40)
        }
    }
    
    fileprivate func centerActivityIndicator() {
        if (activicyIndicator != nil) {
            activicyIndicator.center = convert(center, from: superview)
        }
    }
}

class DefaultViewAnimator: RefreshViewAnimator {
    fileprivate let refreshView: DefaultRefreshView
    
    init(refreshView: DefaultRefreshView) {
        self.refreshView = refreshView
    }
    
    func animateState(_ state: State) {
        switch state {
        case .inital: refreshView.activicyIndicator?.stopAnimating()
        case .releasing(let progress):
            refreshView.activicyIndicator?.isHidden = false

            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: progress, y: progress);
            transform = transform.rotated(by: 3.14 * progress * 2);
            refreshView.activicyIndicator?.transform = transform
        case .loading: refreshView.activicyIndicator.startAnimating()
        default: break
        }
    }
}
