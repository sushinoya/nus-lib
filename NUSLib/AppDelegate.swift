//
//  AppDelegate.swift
//  NUSLib
//
//  Created by wongkf on 13/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import Heimdallr
import XCGLogger
import FacebookCore
import FBSDKLoginKit

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var twitterCreds: OAuthClientCredentials? = {
        // read from external resource TwitterCredentials.json
        if let url = Bundle.main.url(forResource: "TwitterCredentials", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String],
            let consumerKey = jsonResult?["consumer_key"], let consumerSecret = jsonResult?["consumer_secret"] {
            return OAuthClientCredentials(id: consumerKey, secret: consumerSecret)
        }
        return nil
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // configure firebase
        FirebaseApp.configure()

        // Authenticate TwitterKit
        if let twitterCreds = twitterCreds {
            TWTRTwitter.sharedInstance().start(withConsumerKey:twitterCreds.id, consumerSecret:twitterCreds.secret!)
        }

        // configure sierra client
        SierraApiClient.configure()

        // configure logger
        log.setup(level: .debug,
                  showLogIdentifier: false,
                  showFunctionName: false,
                  showThreadName: false,
                  showLevel: true,
                  showFileNames: true,
                  showLineNumbers: true,
                  showDate: true)

        let emojiLogFormatter = PrePostFixLogFormatter()
        emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", to: .verbose)
        emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", to: .debug)
        emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", to: .info)
        emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", to: .warning)
        emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", to: .error)
        emojiLogFormatter.apply(prefix: "💣💣💣 ", to: .severe)

        log.formatters = [emojiLogFormatter]

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {

        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String, annotation: options[.annotation])
    }

}
