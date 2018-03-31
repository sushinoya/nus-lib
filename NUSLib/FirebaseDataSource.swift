//
//  FirebaseDataSource.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 1/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

class FirebaseDataSource: AppDataSource {
    func getPopularItems() -> [DisplayableItem] {
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
        return nil
    }
    
}
