//
//  BookItem.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 17/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class BookItem: DisplayableItem {

    private var title: String
    private var thumbNail: UIImage
    private var rating: Int

    init (name title: String, image: UIImage, rating: Int) {
        self.title = title
        self.thumbNail = image
        self.rating = rating
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
