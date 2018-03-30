//
//  BookItem.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

struct BookItem: DisplayableItem {

    private var title: String
    private var author: String
    private var thumbNail: UIImage
    private var rating: Int
    private var reviews = [Review]()

    init (name title: String, author:String, image: UIImage, rating: Int) {
        self.title = title
        self.author = author
        self.thumbNail = image
        self.rating = rating
    }
    
    init(name title: String, image: UIImage) {
        self.init(name: title, author: "Unknown", image: image, rating: 5)
    }

    init?(json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let author = json["author"] as? String
            else {
                return nil 
            }
        self.title = title
        self.author = author
        self.thumbNail = UIImage()
        self.rating = -1
    }

    init?(json: [String: Any], image: UIImage, rating: Int) {
        self.init(json: json)
        self.thumbNail = image
        self.rating = rating
    }

    func getTitle() -> String {
        return self.title
    }

    func getAuthor() -> String {
        return self.author
    }

    func getThumbNail() -> UIImage {
        return self.thumbNail
    }
    
    func getRating() -> Int {
        return self.rating
    }

}

extension BookItem: Equatable {
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        return lhs.getTitle() == rhs.getTitle() &&
               lhs.getRating() == rhs.getRating() &&
               lhs.getAuthor() == rhs.getAuthor()
    }
}
