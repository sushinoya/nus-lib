//
//  Event.swift
//  NUSLib
//
//  Created by wongkf on 14/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit


class EventViewController: BaseViewController{
    
    override func viewWillLayoutSubviews() {
        webview.fillSuperview()
    }
    
    override func viewDidLoad() {
        self.view.addSubview(webview)
    }
    
    private(set) lazy var webview: UIWebView = {
        let this = UIWebView()
        var request = URLRequest(url: URL(string: "https://libportal.nus.edu.sg/frontend/newsroom")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = "type=All&selectedMonth=All&selectedYear=All&showedRecod=7".data(using: .utf8)
        this.loadRequest(request)
        return this
    }()
}
