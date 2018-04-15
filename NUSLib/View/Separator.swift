//
//  Separator.swift
//  NUSLib
//
//  Created by wongkf on 24/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class Separator: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(width: CGFloat, frame: CGRect = CGRect.zero, thickness: CGFloat = 0.5) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: thickness)))

        backgroundColor = UIColor.gray
    }
}
