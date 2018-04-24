//
//  Event.swift
//  NUSLib
//
//  Created by wongkf on 14/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class EventViewController: BaseViewController {
    
    private(set) lazy var request: URLRequest = {
        var this = URLRequest(url: URL(string: "https://libportal.nus.edu.sg/frontend/newsroom")!)
        this.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        this.httpMethod = "POST"
        this.httpBody = "type=All&selectedMonth=All&selectedYear=All&showedRecod=7".data(using: .utf8)
        return this
    }()
    
    private(set) lazy var webview: UIWebView = {
        let this = UIWebView()
        this.loadRequest(request)
        return this
    }()

    override func viewWillLayoutSubviews() {
        webview.fillSuperview()
    }

    override func viewDidLoad() {
        self.view.addSubview(webview)
    }
}
