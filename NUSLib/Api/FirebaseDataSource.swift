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

    func getPopularItems(completionHandler: @escaping ([String]) -> Void) {
        
        database.child("FavouritesCount").queryOrdered(byChild: "count").queryLimited(toFirst: 10)
            .observe( .value) { (snapshot) in
            
            if snapshot.exists() {
                var bookIds = [String]()

                for child in snapshot.children.reversed() {
                    let snap = child as! DataSnapshot
                    bookIds.append(snap.key)
                }
                completionHandler(bookIds)
            } else {
                print("No popular books")
            }
        }
    }
    
    func getMostViewedItems() -> [DisplayableItem] {
        return []
    }
    
    func getReviewsForBook(bookId: String, completionHandler: @escaping ([Review]) -> Void) {
        let userReviews = database.child("Reviews")
        userReviews.observe(.value) { (snapshot) in
            var reviews = [Review]()
            if snapshot.exists() {
                let data = snapshot.value as? NSDictionary
                for value in (data?.allValues)! {
                    let current = value as! NSDictionary
                    let bookid = current["bookid"] as? String
                    if bookid == bookId {
                        if let text = current["text"] as? String,
                            let rating = current["rating"] as? Int {
                            reviews.append(Review(reviewText: text, rating: rating))
                        }
                    }
                }
            } else {
                print("no reviews exist for \(bookId)")
            }
            completionHandler(reviews)
        }
        
    }
    
    func getReviewsByUser(userID: String, completionHandler: @escaping ([Review]) -> Void) {
        let userReviews = database.child("Reviews")
        userReviews.observe( .value) { (snapshot) in
            var reviews = [Review]()
            if snapshot.exists() {
                let data = snapshot.value as? NSDictionary
                for value in (data?.allValues)! {
                    let current = value as! NSDictionary
                    let authid = current["authid"] as! String
                    if authid == userID {
                        if let text = current["text"] as? String,
                            let rating = current["rating"] as? Int {
                            reviews.append(Review(reviewText: text, rating: rating))
                        }
                    }
                }
            } else {
                print("no reviews exist by \(userID)")
            }
            completionHandler(reviews)
        }
    }

    func addReview(by userId: String,for bookid: String, review: String, rating: Int) {
        let newReview = database.child("Reviews").childByAutoId()
        newReview.child("authid").setValue(userId)
        newReview.child("bookid").setValue(bookid)
        newReview.child("rating").setValue(rating)
        newReview.child("text").setValue(review)
    }
    
    func authenticateUser(email: String, password: String, completionHandler: @escaping (UserProfile?) -> Void)  {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            var currentUser: UserProfile?
            if let successUser = user {
                var name: String
                if successUser.displayName != nil {
                    name = successUser.displayName!
                } else {
                    name = successUser.email?.components(separatedBy: "@").first ?? "guest"
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

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("failed to signout")
        }
    }
    
    func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }

    func updateUserPassword(newPassword: String, completionHandler: @escaping (Constants.resetPasswordState) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("no user")
            return
        }
        user.updatePassword(to: newPassword, completion: { (error) in
            if  let validError = error,
                let errorCode = AuthErrorCode( rawValue: validError._code) {
                switch errorCode {
                    case .weakPassword : completionHandler(Constants.resetPasswordState.weakPassword)
                    case .requiresRecentLogin: completionHandler(Constants.resetPasswordState.loginTimeOut)
                    default : completionHandler(Constants.resetPasswordState.error)
                }
            } else {
                completionHandler(Constants.resetPasswordState.success)
            }
        })
    }

    func getCurrentUser() -> UserProfile? {
        if let user = Auth.auth().currentUser {
            return UserProfile(username: user.email?.components(separatedBy: "@").first ?? "guest", userID: user.uid, email: user.email!)
        } else {
            return nil
        }
    }
    
    func addToFavourite(by userId: String, bookid: String, bookTitle: String, completionHandler: @escaping (Bool) -> ()) {
        let userFavourite = database.child("UserFavourites").child(userId)
        
        userFavourite.queryOrdered(byChild: "bookid").queryEqual(toValue: "\(bookid)").observeSingleEvent(of: .value) { (snapshot) in
            var isSuccess = false
            if snapshot.exists() {
                print("Duplicate bookid")
                isSuccess = false
            } else {
                let autoId = userFavourite.childByAutoId()
                autoId.child("bookid").setValue(bookid)
                autoId.child("bookTitle").setValue(bookTitle)
                isSuccess = true
            }
            completionHandler(isSuccess)
        }
    }
    
    func deleteFavourite(by userId: String, bookid: String, completionHandler: @escaping () -> ()) {
        let userFavourite = database.child("UserFavourites").child(userId)
        userFavourite.queryOrdered(byChild: "bookid").queryEqual(toValue: "\(bookid)").observeSingleEvent(of: .value) { (snapshots) in
            if snapshots.exists() {
                for snap in snapshots.children {
                    let userSnap = snap as! DataSnapshot
                    userSnap.ref.removeValue(completionBlock: { (error, ref) in
                        completionHandler()
                    })
                }
            } else {
                print("record not found")
            }
        }
    }
    
    func getFavourite(by userId: String, bookid: String, completionHandler: @escaping (Bool) -> Void) {
        let userFavourite = database.child("UserFavourites").child(userId)
        userFavourite.queryOrdered(byChild: "bookid").queryEqual(toValue: "\(bookid)").observeSingleEvent(of: .value) { (snapshot) in
            completionHandler(snapshot.exists())
        }
    }
    
    func getFavouriteBookListForUser(userID: String, completionHandler: @escaping ([String]) -> Void) {
        let ref = database.child("UserFavourites").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                var bookIds = [String]()
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        let bookid = child.childSnapshot(forPath: "bookid").value as! String
                        bookIds.append(bookid)
                    }
                }
                completionHandler(bookIds)
            } else {
                print("Record not found")
            }
        }
    }
    
    func updateCount(bookid: String, value: Int) {
        
        database.child("FavouritesCount").child("\(bookid)").runTransactionBlock({ (data) -> TransactionResult in
            if var bibs = data.value as? [String: AnyObject] {
                
                var dummyVal = bibs["count"] as? Int ?? 0
                
                dummyVal = dummyVal + value
                
                bibs["count"] = dummyVal as AnyObject?
                
                data.value = bibs
            }
            
            return TransactionResult.success(withValue: data)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func addFeedback(by userId: String, feedback: String) {
        let newReview = database.child("Feedback").childByAutoId()
        newReview.child("authid").setValue(userId)
        newReview.child("feedback").setValue(feedback)
    }
}
