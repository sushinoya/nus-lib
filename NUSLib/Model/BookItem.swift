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
    typealias builderClosure = (BookItem) -> Void
   
    var id: String?
    var title: String?
    var thumbnail: UIImage?
    var rating: Int?
    var author: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id      <- map["id"]
        title   <- map["title"]
        author  <- map["author"]
    }
    
    init(build: builderClosure) {
        build(self)
    }
    
    /*
    init (id: String, name title: String, author:String, image: UIImage, rating: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.thumbnail = image
        self.rating = rating
    }
    
    init(id: String, name title: String, image: UIImage) {
        self.init(id: id, name: title, author: "Unknown", image: image, rating: 5)
    }

    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let author = json["author"] as? String
            else {
                return nil 
            }
        self.id = id
        self.title = title
        self.author = author
        self.thumbnail = UIImage()
        self.rating = -1
    }

    init?(json: [String: Any], image: UIImage, rating: Int) {
        self.init(json: json)
        self.thumbnail = image
        self.rating = rating
    }*/
}

extension BookItem: Equatable {
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        return lhs.title == rhs.title &&
               lhs.rating == rhs.rating &&
               lhs.author == rhs.author
    }
}
