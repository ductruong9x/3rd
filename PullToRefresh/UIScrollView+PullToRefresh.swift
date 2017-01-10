//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToRefresh
//

import Foundation
import UIKit
import ObjectiveC

private var associatedObjectHandle: UInt8 = 0

public extension UIScrollView {
    fileprivate(set) var pullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &associatedObjectHandle) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addPullToRefresh(_ pullToRefresh: PullToRefresh, action:@escaping ()->()) {
        if self.pullToRefresh != nil {
            self.removePullToRefresh(self.pullToRefresh!)
        }
        
        self.pullToRefresh = pullToRefresh
        pullToRefresh.scrollView = self
        pullToRefresh.action = action
        
        let view = pullToRefresh.refreshView
        view.frame = CGRect(x: 0, y: -view.frame.size.height, width: self.frame.size.width, height: view.frame.size.height)
        self.addSubview(view)
        self.sendSubview(toBack: view)
    }
    
    func removePullToRefresh(_ pullToRefresh: PullToRefresh) {
        self.pullToRefresh?.refreshView.removeFromSuperview()
        self.pullToRefresh = nil
    }
    
    func startRefreshing() {
        pullToRefresh?.startRefreshing()
    }
    
    func endRefreshing() {
        pullToRefresh?.endRefreshing()
    }
}
