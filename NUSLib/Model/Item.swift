//
//  Item.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 15/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

/* This protocol contains the basic functionalities expected from any kind of 'item' we'll be dealing with,
 such as 'Book', 'Exam Paper' or 'Journal'. The title would be the basic title of the item, thumbnail would
 be the image thumbnail associated with this object, and rating holds a rating of this item, if any.
 */

protocol Item {

    func getTitle()
    func getThumbNail()
    func getRating()

}
