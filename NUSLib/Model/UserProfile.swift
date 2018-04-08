//
//  UserProfile.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 15/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

class UserProfile {

    private var username: String
    private var userID: String
    private var email: String

    init(username: String, userID: String, email: String) {
        self.username = username
        self.userID = userID
        self.email = email
    }

    func getUsername() -> String {
        return self.username
    }
    
    func getUserID() -> String {
        return self.userID
    }
    
    func getEmail() -> String {
        return self.email
    }
}
