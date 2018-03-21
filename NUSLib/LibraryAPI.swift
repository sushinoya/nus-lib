//
//  LibraryAPI.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

protocol LibraryAPI {

    func getDisplayableItems() -> [DisplayableItem]
    func getBooksFromTitle(title: String) -> [BookItem]
    func getBooksFromISBN(barcode: String) -> [BookItem]

}
