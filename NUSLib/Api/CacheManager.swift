//
//  CacheManager.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 12/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private var cache: NSCache<NSString, BookItem>
    
    func addToCache(itemID: String, item: BookItem) {
        cache.setObject(item, forKey: itemID as NSString)
    }

    func retrieveFromCache(itemID: String) -> BookItem? {
        return cache.object(forKey: itemID as NSString)
    }

    private init() {
        cache = NSCache<NSString, BookItem>()
    }
    
}
