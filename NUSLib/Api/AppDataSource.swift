//
//  AppDataSource.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 1/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

/*
    Protocol that defines methods that external database should provide for
    managing functionalities such as User Authentication, Favourites, Book Reviews etc
 */

protocol AppDataSource {

    func getPopularItems(completionHandler: @escaping ([String]) -> Void)
    func getMostViewedItems() -> [DisplayableItem]
    
    func addReview(by userId: String,for bookid: String, review: String, rating: Int)
    func getReviewsForBook(bookId: String, completionHandler: @escaping ([Review]) -> Void)
    func getReviewsByUser(userID: String, completionHandler: @escaping ([Review]) -> Void)

    func authenticateUser(email: String, password: String, completionHandler: @escaping (UserProfile?) -> Void)
    func isUserSignedIn() -> Bool
    func getCurrentUser() -> UserProfile?
    
    func addToFavourite(by userId: String, bookid: String, bookTitle: String, completionHandler: @escaping (Bool) -> ())
    func deleteFavourite(by userId: String, bookid: String, completionHandler: @escaping () -> ())
    func getFavourite(by userId: String, bookid: String, completionHandler: @escaping (Bool) -> Void)
    func getFavouriteBookListForUser(userID: String, completionHandler: @escaping ([String]) -> Void)
}
