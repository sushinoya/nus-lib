//
//  UserProfile.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 15/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

class UserProfile {

    private(set) var username: String
    private(set) var password: String

    init (username: String, password: String) {
        self.username = username
        self.password = password
    }
}
