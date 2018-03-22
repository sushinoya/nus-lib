//
//  SierraApi.swift
//  NUSLib
//
//  Created by wongkf on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Moya

enum SierraApi {
    case bib(id: String)
    case bibs(limit: Int, offset: Int)
    case bibsSearch(limit: Int, offset: Int, index: String, text: String)
    case branches(limit: Int, offset: Int)
}

extension SierraApi: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: "https://sandbox.iii.com/iii/sierra-api/v3")!
    }
    
    var path: String {
        switch self {
        case .bib(let id): return "/bibs/\(id)"
        case .bibs(_): return "/bibs"
        case .bibsSearch(_): return "/bibs/search"
        case .branches(_): return "/branches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .bib, .bibs, .bibsSearch, .branches:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .bib(_): return "bib.".data(using: .utf8)!
        case .bibs(_): return "bibs.".data(using: .utf8)!
        case .bibsSearch(_): return "bibsSearch.".data(using: .utf8)!
        case .branches(_): return "branches.".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .bib(_): return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case let .bibs(limit, offset): return .requestParameters(parameters: ["limit": limit, "offset": offset], encoding: URLEncoding.queryString)
        case let .bibsSearch(limit, offset, index, text): return .requestParameters(parameters: ["limit": limit, "offset": offset, "index": index, "text": text], encoding: URLEncoding.queryString)
        case let .branches(limit, offset): return .requestParameters(parameters: ["limit": limit, "offset": offset], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var authorizationType: AuthorizationType {
        return .bearer
    }
    
}
