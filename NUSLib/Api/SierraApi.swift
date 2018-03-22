//
//  SierraApi.swift
//  NUSLib
//
//  Created by wongkf on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Moya

enum SierraApi {
    case items(limit: Int)
    case branches(limit: Int)
}

extension SierraApi: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: "https://sandbox.iii.com/iii/sierra-api/v3")!
    }
    
    var path: String {
        switch self {
        case .items(_): return "/items"
        case .branches(_): return "/branches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .items, .branches:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .items(_): return "items.".data(using: .utf8)!
        case .branches(_): return "branches.".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case let .items(limit): return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case let .branches(limit): return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    var authorizationType: AuthorizationType {
        return .bearer
    }
    
}

