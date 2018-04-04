//
//  BookItem.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import ObjectMapper

class BookItem: DisplayableItem, Mappable {
    
    var id: String?
    var title: String?
    var thumbnail: UIImage?
    var rating: Int?
    var author: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        title   <- map["title"]
        author  <- map["author"]
    }
    
    init(build: (BookItem) -> Void) {
        build(self)
    }
}

extension BookItem: Equatable {
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        return lhs.title == rhs.title &&
               lhs.rating == rhs.rating &&
               lhs.author == rhs.author
    }
}
