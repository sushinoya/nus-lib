//
//  UIView+RoundCorners.swift
//  NUSLib
//
//  Created by wongkf on 26/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import ChainableAnimations
import Heimdallr

extension UIView {
    
    func animateFadeIn() {
        self.alpha = 0        
        ChainableAnimator(view: self)
            .make(alpha: 1)
            .animate(t: 0.5)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
