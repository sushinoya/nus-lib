//
//  SocialButton.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 30/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import UIKit
import ZFRippleButton

class SocialButton: ZFRippleButton {

    init(type: SocialButtonType) {
        super.init(frame: CGRect(x: 160, y: 100, width: 50, height: 50))
        self.setImage(imageForButton(type: type), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = colorForButton(type: type)
        self.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.rippleColor = UIColor.white.withAlphaComponent(0.2)
        self.ripplePercent = 0.95
        self.rippleBackgroundColor = UIColor.clear
        self.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func imageForButton(type: SocialButtonType) -> UIImage {
        switch type {
        case .facebook:
            return UIImage(named: "fb-white")!
        case .twitter:
            return UIImage(named: "twitter-white")!
        }
    }

    func colorForButton(type: SocialButtonType) -> UIColor {
        switch type {
        case .facebook:
            return UIColor.facebookSocial
        case .twitter:
            return UIColor.twitterSocial
        }
    }
}

enum SocialButtonType {
    case facebook
    case twitter
}
