//
//  BorderView.swift
//  TestLyft
//
//  Created by TruongVuDucTruong on 1/10/17.
//  Copyright © 2017 TruongVuDucTruong. All rights reserved.
//

import UIKit

class BorderView: UIView {
    
    var heightLine: CGFloat = 0.5
    
    @IBInspectable var bottomLineBorder: UIColor?{
        didSet {
            if self.viewWithTag(333) == nil{
                let border = UIView()
                border.tag = 333
                border.backgroundColor = bottomLineBorder
                border.clipsToBounds = true
                self.addSubview(border)
                border.translatesAutoresizingMaskIntoConstraints = false
                let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1.0, constant: 0.0)
                let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading , multiplier: 1.0, constant: 0.0)
                let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing , multiplier: 1.0, constant: 0.0)
                let height:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: heightLine)
                self.addConstraints([bottomMargin,leftMargin,rightMargin,height])
            }else{
                self.viewWithTag(333)?.backgroundColor = bottomLineBorder
            }
        }
        
    }
    
    
    @IBInspectable var topLineBorder: UIColor?{
        didSet {
            if self.viewWithTag(334) == nil{
                let border = UIView()
                border.tag = 334
                border.backgroundColor = topLineBorder
                border.clipsToBounds = true
                self.addSubview(border)
                border.translatesAutoresizingMaskIntoConstraints = false
                let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top , multiplier: 1.0, constant: 0.0)
                let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading , multiplier: 1.0, constant: 0.0)
                let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing , multiplier: 1.0, constant: 0.0)
                let height:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: heightLine)
                self.addConstraints([bottomMargin,leftMargin,rightMargin,height])
            }else{
                self.viewWithTag(334)?.backgroundColor = topLineBorder
                
            }
        }
    }
    
    @IBInspectable var leftLineBorder: UIColor?{
        didSet {
            if self.viewWithTag(335) == nil{
                let border = UIView()
                border.tag = 335
                border.backgroundColor = leftLineBorder
                border.clipsToBounds = true
                self.addSubview(border)
                
                border.translatesAutoresizingMaskIntoConstraints = false
                //                self.translatesAutoresizingMaskIntoConstraints = false
                let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top , multiplier: 1.0, constant: 0.0)
                let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading , multiplier: 1.0, constant: 0.0)
                let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1.0, constant: 0.0)
                let height:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: self.frame.height)
                
                let width:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: heightLine)
                self.addConstraints([bottomMargin,leftMargin,rightMargin,height,width])
            }else{
                self.viewWithTag(335)?.backgroundColor = leftLineBorder
                
            }
            
        }
    }
    
    @IBInspectable var rightLineBorder: UIColor?{
        didSet {
            if self.viewWithTag(336) == nil{
                let border = UIView()
                border.tag = 336
                border.backgroundColor = rightLineBorder
                border.clipsToBounds = true
                self.addSubview(border)
                
                border.translatesAutoresizingMaskIntoConstraints = false
                //                self.translatesAutoresizingMaskIntoConstraints = false
                let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top , multiplier: 1.0, constant: 0.0)
                let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing , multiplier: 1.0, constant: 0.0)
                let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom , multiplier: 1.0, constant: 0.0)
                let height:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: self.frame.height)
                
                let width:NSLayoutConstraint = NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: heightLine)
                self.addConstraints([bottomMargin,leftMargin,rightMargin,height,width])
            }else{
                self.viewWithTag(336)?.backgroundColor = rightLineBorder
                
            }
            
        }
    }
    
}
