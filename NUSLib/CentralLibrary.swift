//
//  CentralLibrary.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

//Instance of LibraryAPI from the Central Library and it's data
class CentralLibrary: LibraryAPI {

    func getDisplayableItems() -> [DisplayableItem] {
        return []
    }

    func getBooksFromTitle(title: String) -> [BookItem] {
        return []
    }

    func getBooksFromISBN(barcode: String) -> [BookItem] {
        return []
    }

}
