//
//  BookItem.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

//Book Item
class BookItem: DisplayableItem {
    var title: String
    var author: String
    var image: UIImage?
    var rating: Int?
    
    init(title: String, author: String, image: UIImage) {
        self.title = title
        self.author = author
        self.image = image
    }
    
    convenience init(title: String, image: UIImage) {
        self.init(title: title, author: "Unknown", image: image)
    }
    
    func getTitle() -> String {
        return title
    }
    
    //Return NIL image
    func getThumbNail() -> UIImage {
        if let image = image {
            return image
        }
        return UIImage()
    }
    
    func getRating() -> Int {
        return rating
    }
}
