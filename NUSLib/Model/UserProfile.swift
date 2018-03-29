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

    private(set) var favourites = [BookItem]()

    init (username: String, password: String) {
        self.username = username
        self.password = password
    }

    func addToFavourites(book: BookItem) {
        let books = favourites.filter{ $0 == book }
        guard books.count == 0 else {
            return
        }
        self.favourites.append(book)
        //Use Notification center to update favourites, and FavouriteVC gets an alert
    }

    func removeFromFavourites(book: BookItem) {
        //Use Notification center to update favourites, and FavouriteVC gets an alert
        self.favourites = self.favourites.filter { $0 != book }
    }

    func authenticate() -> Bool {
        //MARK : Do Ivle/UserProfile authentication here, and return boolean result
        return true
    }
}
