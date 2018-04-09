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

    func getBook(byId id: String, completionHandler: @escaping ((BookItem) -> Void))
    func getBook(byId id: String) -> Observable<BookItem>
    func getBook(byISBN isbn: String) -> Observable<BookItem>
    func getBooks(byTitle title: String) -> Observable<[BookItem]>
    func getBooks(byAuthor author: String) -> Observable<[BookItem]>
    func getBooksRecommendation(byTitle title: String) -> Observable<[BookItem]>

}
