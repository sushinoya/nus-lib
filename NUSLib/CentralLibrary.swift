//
//  CentralLibrary.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import RxSwift
import Moya

//Instance of LibraryAPI from the Central Library and it's data
class CentralLibrary: LibraryAPI {
    
    fileprivate func transformJSON(_ data: Data, _ books: inout [BookItem]) {
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        if let rootDictionary = jsonObject as? [String: Any],
           let items = rootDictionary["entries"] as? [[String: Any]] {
            for item in items {
                if let book = BookItem(json: item["bib"] as! [String : Any]) {
                    books.append(book)
                }
            }
        }
    }
    
    func getBooksFromTitle(title: String) -> [BookItem] {
        var books = [BookItem]()
        SierraApiClient.shared.provider.request(.bibsSearch(limit: 10, offset: 0, index: "title", text: title), completion: {
            switch $0 {
                case let .success(moyaResponse):
                    self.transformJSON(moyaResponse.data, &books)
                case let .failure(error):
                    print(error.errorDescription!)
                }
            })
        return books
    }
    
    func getBooksFromISBN(barcode: String) -> [BookItem] {
        return []
    }
    
    
    func getBooksFromKeyword(keyword: String) -> Observable<[BookItem]> {
        
        return Observable.create { observer in
            var books = [BookItem]()
            SierraApiClient.shared.provider.request(.bibsSearch(limit: 10, offset: 0, index: "title", text: keyword), completion: {
                switch $0 {
                case let .success(moyaResponse):
                    self.transformJSON(moyaResponse.data, &books)
                    observer.onNext(books)
                    observer.onCompleted()
                case let .failure(error):
                    print(error.errorDescription!)
                }
            })
            return Disposables.create()
        }
    }
    
}
