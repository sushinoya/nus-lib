//
//  BookItem.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class BookItem: DisplayableItem {

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
    
    convenience init(name title: String, image: UIImage) {
        self.init(name: title, author: "Unknown", image: image, rating: 5)
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
