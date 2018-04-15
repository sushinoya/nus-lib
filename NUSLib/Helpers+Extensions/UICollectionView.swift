//
//  UICollectionView.swift
//  NUSLib
//
//  Created by wongkf on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension UICollectionView {

    func displayEmptyResult(message: String = "No Result") {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.font = UIFont.fontAwesome(ofSize: 20)
        messageLabel.text = String.fontAwesomeIcon(name: .frownO) +  " " + message
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }
}
