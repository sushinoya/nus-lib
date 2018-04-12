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
    
    private var cache = [String: DisplayableItem]()
    
    func addToCache(itemID: String, item: DisplayableItem) {
        cache[itemID] = item
    }

    func retrieveFromCache(itemID: String) -> DisplayableItem? {
        return cache[itemID]
    }

    func clearCache() {
        cache = [:]
    }

    private init() {
        
    }
}
