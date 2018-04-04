//
//  FirebaseDataSource.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 1/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataSource {
    private var database: DatabaseReference
    
    init() {
        self.database = Database.database().reference()
    }

    func getPopularItems() -> [DisplayableItem] {
        self.database.child("Popular")
        return []
    }
    
    func getMostViewedItems() -> [DisplayableItem] {
        return []
    }
    
    func getReviewsForItem(itemID: Int) -> [Review] {
        return []
    }
    
    func getReviewsByUser(userID: Int) -> [Review] {
        return []
    }
    
    func getFavouritesForUser(userID: Int) -> [Int] {
        return []
    }
    
    func authenticateUser(email: String, password: String, completionHandler: @escaping (UserProfile?) -> Void)  {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            var currentUser: UserProfile?
            if let successUser = user {
                var name: String
                if successUser.displayName != nil {
                    name = successUser.displayName!
                } else {
                    name = "USER1"
                }
                currentUser = UserProfile(username: name, userID: successUser.uid, email: email)
                print("success")
            } else {
                currentUser = nil
                print("fail")
            }
            completionHandler(currentUser)
        }
    }
    
}
