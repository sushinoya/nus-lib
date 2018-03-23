//
//  ScrollView+FitToContent.swift
//  NUSLib
//
//  Created by wongkf on 24/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    // this method will calculate the optimal dimension to fit to its content
    func fitToContent() {
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            //print("scrollview: \(view.frame.size)" )
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
