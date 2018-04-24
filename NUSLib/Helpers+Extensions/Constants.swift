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

    enum NavigationBarTitle {
        static let ItemDetailTitle = "Item Detail"
        static let SearchTitle = "Search"
        static let FavouriteTitle = "Favourite"
        static let LoginTitle = "Login"
        static let AccountTitle = "Account"
        static let HomeTitle = "Home"
        static let AboutTitle = "About"
    }

    enum resetPasswordState: String {
        case success = "Successfully reset password!"
        case loginTimeOut = "It seems you have not logged in recently enough to complete this reset"
        case weakPassword = "The new password is too weak"
        case error = "Could not complete this request at the moment"
    }
}

// app theme & color branding
extension UIColor {
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

    // social buttons
    static let facebookSocial = UIColor("#3B5998")
    static let twitterSocial = UIColor("#00ACED")

    static let goodreadsSocial = UIColor("#F2F0E6")
    static let googleSocial = UIColor("#EDEDED")
}

extension UIFont {
    static let primary = UIFont(name: "Avenir-Heavy", size: 32)
    static let secondary = UIFont(name: "Avenir-Heavy", size: 28)
    static let title = UIFont(name: "Avenir-Heavy", size: 16)
    static let subtitle = UIFont(name: "Avenir-Heavy", size: 12)
    static let subsubtitle = UIFont(name: "Avenir", size: 11)
    static let content = UIFont(name: "Avenir", size: 16)
    static let reviewContent = UIFont(name: "Avenir", size: 12)
    static let reviewPost = UIFont(name: "Avenir", size: 24)
}
