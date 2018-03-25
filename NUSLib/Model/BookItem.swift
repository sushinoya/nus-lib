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

    func getTitle() -> String {
        return self.title
    }
    
    func getThumbNail() -> UIImage {
        return self.thumbNail
    }
    
    func getRating() -> Int {
        return self.rating
    }

}

