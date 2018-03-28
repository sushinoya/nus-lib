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
    
    func getDisplayableItems() -> [DisplayableItem] {
        var books = [BookItem]()
        SierraApiClient.shared.provider.request(.bibs(limit: 10, offset: 0)){ result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                //let statusCode = moyaResponse.statusCode
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let rootDictionary = jsonObject as? [String: Any],
                        let items = rootDictionary["entries"] as? [[String: Any]] {
                        for item in items {
                            let url = URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg")
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)
                            let rating = Int(arc4random_uniform(5))
                            if let book = BookItem(json: item, image: image!, rating: rating) {
                                print("parsed... \(book)")
                                books.append(book)
                            }
                        }
                    }
                } catch {
                    
                }
            case let .failure(error):
                print(error.errorDescription!)
            }
        }
        return books
    }
    
    func getBooksFromTitle(title: String) -> [BookItem] {
        var books = [BookItem]()
        var result: Data?
        
        SierraApiClient.shared.provider.request(.bibsSearch(limit: 10, offset: 0, index: "title", text: title)) {
        switch $0 {
            case let .success(moyaResponse):
                result = moyaResponse.data
            case let .failure(error):
                print(error.errorDescription!)
            }
        }
        
        if let data = result {
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
        return books
    }
    
    func getBooksFromISBN(barcode: String) -> [BookItem] {
        return []
    }
    
    
    func getBooksFromKeyword(keyword: String) -> Observable<[BookItem]> {
        
        return Observable.create { observer in
            let books: [BookItem] = self.getBooksFromTitle(title: keyword)
            observer.onNext(books)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
