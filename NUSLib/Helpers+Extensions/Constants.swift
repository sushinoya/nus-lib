//
//  Constants.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 15/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    enum Colors {
        static let titleColor = "#F2C777"
        static let backgroundColor = "#092140"
    }
    
    enum NavigationBarTitle {
        static let ItemDetailTitle = "Item Detail"
        static let SearchTitle = "Search"
        static let FavouriteTitle = "Favourite"
        static let LoginTitle = "Login"
        static let HomeTitle = "Home"
    }
}

// app theme & color branding
extension UIColor{
    // primary
    static let navyBlue = UIColor("#092140")
    static let primary = UIColor.navyBlue
    
    // primary tint
    static let navyBlueTint1 = UIColor("#213753")
    static let primaryTint1 = UIColor.navyBlueTint1
    
    // accents
    static let elfGreen = UIColor("#024959")
    static let accent1 = UIColor.elfGreen
    
    static let custardYellow = UIColor("#F2C777")
    static let accent2 = UIColor.custardYellow
    
    static let milkyWhite = UIColor("#E6E7E8")
    static let accent3 = UIColor.milkyWhite
    
    static let lipstickRed = UIColor("#BF2A2A")
    static let accent4 = UIColor.lipstickRed
}

extension UIFont{
    static let primary = UIFont(name: "Avenir-Heavy", size: 32)
    static let subtitle = UIFont(name: "Avenir-Heavy", size: 12)
}
