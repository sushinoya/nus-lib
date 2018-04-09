//
//  SierraApiClient.swift
//  NUSLib
//
//  Created by wongkf on 22/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Moya
import Heimdallr
import Result
import UIKit

/**
 SierraApiClient encapsulate authentication process from client.
 This class will automatically look for "SierraApi.json" for API credentials.
 
 Upon requesting for resource, it will automatically request for accesstoken if it cannot find any valid token.
 
 Note that the token will be persisted, which means the token will be stored in device after app closes.
 */
class SierraApiClient {
    static let shared = SierraApiClient()
    
    final let NO_ACCESSTOKEN_FOUND = "no accesstoken found"
    final let CANNOT_READ_CREDENTIALS = "cannot read credentials"
    
    private let accessTokenStore = OAuthAccessTokenKeychainStore(service: "SierraApi")
    private let accessTokenUrl = URL(string: "https://sandbox.iii.com/iii/sierra-api/v3/token")!
    
    private lazy var credentials: OAuthClientCredentials? = {
        // read from external resource SierraApi.json
        if let url = Bundle.main.url(forResource: "SierraApi", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String],
            let clientId = jsonResult?["client_id"], let clientSecret = jsonResult?["client_secret"] {
            return OAuthClientCredentials(id: clientId, secret: clientSecret)
        }
        
        print(CANNOT_READ_CREDENTIALS)
        
        return nil
    }()
    
    private var accessToken: String {
        return accessTokenStore.retrieveAccessToken()?.accessToken ?? NO_ACCESSTOKEN_FOUND
    }
    
    private lazy var accessTokenPlugin = AccessTokenPlugin(tokenClosure: self.accessToken)
    
    lazy var provider: MoyaProvider<SierraApi> = MoyaProvider<SierraApi>( requestClosure: { (endpoint, done) in
        Heimdallr(tokenURL: self.accessTokenUrl, credentials: self.credentials, accessTokenStore: self.accessTokenStore)
            .requestAccessToken(grantType: "client_credentials", parameters: [:]) { result in
                log.debug("Requested new accesstoken.")
                log.info("\(self.accessToken)")
                done(Result<URLRequest, MoyaError>(value: try! endpoint.urlRequest()))
        }
    }, stubClosure: MoyaProvider.neverStub, plugins: [accessTokenPlugin])
    
    private init(){
        // singleton to restrict creating multiple instances of this class
    }
}
