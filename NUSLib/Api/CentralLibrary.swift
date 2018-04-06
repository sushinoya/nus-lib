//
//  CentralLibrary.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import RxSwift
import RxOptional
import Moya
import ObjectMapper

//Instance of LibraryAPI from the Central Library and it's data
class CentralLibrary: LibraryAPI {
    /*
    fileprivate func transformJSON(_ data: Data, _ books: inout [BookItem]) {
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        if let rootDictionary = jsonObject as? [String: Any],
           let items = rootDictionary["entries"] as? [[String: Any]] {
            for item in items {
                /*if let book = BookItem(json: item["bib"] as! [String : Any]) {
                    books.append(book)
                }*/
            }
        }
    }
    */
    
    func getBook(byId id: String) -> Observable<BookItem> {
        return SierraApiClient.shared.provider                              // initialize api client
            .rx                                                             // moya rx extension
            .request(.bib(id: id))                                          // setup request endpoint
            .filterSuccessfulStatusCodes()
            .map{Mapper<BookItem>().map(JSONObject: try $0.mapJSON())}      // transform the json string into programmable BookItem object
            .asObservable()                                                 // cast into observable so the caller than observe on the value returned
            .filterNil()                                                    // remove any nil elements, make it non-optional
    }
    
    func getBooks(byTitle title: String) -> Observable<[BookItem]> {
        return SierraApiClient.shared.provider
            .rx
            .request(.bibsSearch(limit: 10, offset: 0, index: "title", text: title))
            .filterSuccessfulStatusCodes()
            .map({ (response) -> [BookItem]? in
                
                let jsonObject = try response.mapJSON()                 // transform response data to json object
                let root = jsonObject as? [String: Any]                 // cast to root level dictionary
                let entries = root?["entries"] as? [[String: Any]]      // cast the key at "entries" into array of dictionary
                
                let bibs = entries?.flatMap{ $0["bib"]}                 // cherry pick the key at "bib" and flatten the array
                
                return Mapper<BookItem>().mapArray(JSONObject: bibs)    // map each json object into array of BookItem object
            })
            .asObservable()
            .filterNil()
    }
    
    func getBooks(byAuthor author: String) -> Observable<[BookItem]> {
        return SierraApiClient.shared.provider
            .rx
            .request(.bibsSearch(limit: 10, offset: 0, index: "author", text: author))
            .filterSuccessfulStatusCodes()
            .map({ (response) -> [BookItem]? in
                
                let jsonObject = try response.mapJSON()                 // transform response data to json object
                let root = jsonObject as? [String: Any]                 // cast to root level dictionary
                let entries = root?["entries"] as? [[String: Any]]      // cast the key at "entries" into array of dictionary
                
                let bibs = entries?.flatMap{ $0["bib"]}                 // cherry pick the key at "bib" and flatten the array
                
                return Mapper<BookItem>().mapArray(JSONObject: bibs)    // map each json object into array of BookItem object
            })
            .asObservable()
            .filterNil()
    }
    
    
    func getBooksFromISBN(barcode: String) -> [BookItem] {
        return []
    }
    
}
