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
import GoogleBooksApiClient

//Instance of LibraryAPI from the Central Library and it's data
class CentralLibrary: LibraryAPI {

    
    func getBooks(byIds ids: [String], completionHandler: @escaping (([BookItem]) -> Void)) {
        let myGroup = DispatchGroup()
        
        var books = [BookItem]()
        for id in ids {
            myGroup.enter()
            SierraApiClient.shared.provider.request(.bib(id: id)) { result in
                switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                        
                        let book = BookItem{
                            $0.id = jsonObject["id"] as? String
                            $0.title = jsonObject["title"] as? String
                            $0.author = jsonObject["author"] as? String
                        }
                        
                        books.append(book)
                        myGroup.leave()
                    } catch {
                        print(error)
                    }
                    
                case let .failure(error):
                    print(error)
                    return
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            completionHandler(books)
        }
        
    }
    
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
    
    func getBooksRecommendation(byTitle title: String) -> Observable<[BookItem]> {
        return URLSession.shared
            .rx
            .response(request: GoogleBooksApi.VolumeRequest.List(query: "intitle:\(title)"))
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .map({ (volumes) -> [BookItem] in
                return volumes.items.map({ (volume) -> BookItem in
                    return BookItem {
                        $0.title = volume.volumeInfo.title
                        $0.author = volume.volumeInfo.authors.first
                        $0.thumbnail = volume.volumeInfo.imageLinks?.thumbnail
                    }
                })
            })
    }
    
    
    func getBook(byISBN isbn: String) -> Observable<BookItem> {
        return URLSession.shared
            .rx
            .response(request: GoogleBooksApi.VolumeRequest.List(query: "isbn:\(isbn)"))
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))              // do the network request on concurrent thread
            .observeOn(MainScheduler.instance)                                              // observe the response on main thread
            .map({ (volumes) -> BookItem? in
                return volumes.items.map({ (volume) -> BookItem in
                    return BookItem {
                        $0.title = volume.volumeInfo.title
                        $0.author = volume.volumeInfo.authors.first
                        $0.thumbnail = volume.volumeInfo.imageLinks?.thumbnail
                    }
                }).first
            })
            .filterNil()
    }
    
}
