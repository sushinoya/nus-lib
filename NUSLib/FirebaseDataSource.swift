//
//  FirebaseDataSource.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 1/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataSource: AppDataSource {
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
    
    func authenticateUser(email: String, password: String) -> UserProfile? {
        var currentUser: UserProfile?
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let successUser = user {
                currentUser = UserProfile(username: successUser.displayName!, userID: successUser.uid, email: email)
            } else {
                currentUser = nil
            }
        }
        return currentUser
    }
    
}
