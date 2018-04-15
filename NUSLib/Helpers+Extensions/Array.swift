//
//  Array.swift
//  NUSLib
//
//  Created by wongkf on 13/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

extension Array {
    var evenEntries: [Element] {
        return stride(from: 0, to: self.count, by: 2).map { self[$0] }
    }

    var oddEntries: [Element] {
        return stride(from: 1, to: self.count, by: 2).map { self[$0] }
    }
}
