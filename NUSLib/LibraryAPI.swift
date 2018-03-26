//
//  LibraryAPI.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import RxSwift

/*
  Protocol that sits in between the server and the mobile frontend. Describes the methods to be used by the app
 to generate the data needed from the library database.
 */
protocol LibraryAPI {

    func getDisplayableItems() -> [DisplayableItem]
    func getBooksFromTitle(title: String) -> [BookItem]
    func getBooksFromISBN(barcode: String) -> [BookItem]
    
    func getBooksFromKeyword(keyword: String) -> Observable<[BookItem]>

}
