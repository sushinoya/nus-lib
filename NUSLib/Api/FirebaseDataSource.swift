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

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("failed to signout")
        }
    }
    
    func addReview(by authorid: String, about bookid: String, text: String) {
        
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
    

    func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }

    func getCurrentUser() -> UserProfile? {
        if let user = Auth.auth().currentUser {
            return UserProfile(username: "USER1", userID: user.uid, email: user.email!)
        } else {
            return nil
        }
    }
}
