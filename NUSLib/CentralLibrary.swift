//
//  CentralLibrary.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

//Instance of LibraryAPI from the Central Library and it's data
class CentralLibrary: LibraryAPI {

    func getDisplayableItems() -> [DisplayableItem] {
        var books = [BookItem]()
        SierraApiClient.shared.provider.request(.bibs(limit: 10, offset: 1)){ result in
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
        SierraApiClient.shared.provider.request(.bib(id: title)){ result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let rootDictionary = jsonObject as? [String: Any],
                       let items = rootDictionary["entries"] as? [[String: Any]] {
                        for item in items {
                            if let book = BookItem(json: item) {
                                print("parsed... \(book)")
                                books.append(book)
                            }
                        }
                    }
                } catch {
                    
                }
                print("\(statusCode):\(String(data: data, encoding: String.Encoding.utf8)!)")
            case let .failure(error):
                print(error.errorDescription!)
            }
        }

        return books
    }

    func getBooksFromISBN(barcode: String) -> [BookItem] {
        return []
    }

}
