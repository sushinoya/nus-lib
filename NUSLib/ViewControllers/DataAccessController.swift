//
//  DataAccessController.swift
//  NUSLib
//
//  Created by S. Ram Janarthana Raja on 1/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation

protocol DataAccessController {

    var itemDetail: DisplayableItem? { get set }
    var user: UserProfile? { get set }
}
