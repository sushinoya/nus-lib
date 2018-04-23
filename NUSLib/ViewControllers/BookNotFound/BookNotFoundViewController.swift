//
//  BookNotFoundViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 15/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import ZFRippleButton

class BookNotFoundViewController: BaseModalViewController {

    var bookTitle: String?
    var bookISBN: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }

    // MARK: - Lazy initialisation of views
    private func addSubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(descLabel)
        self.view.addSubview(goodreadsButton)
        self.view.addSubview(googleButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        //Title
        titleLabel.anchorInCenter(width: 400, height: 150)
        titleLabel.center.y -= 150

        descLabel.align(.underCentered, relativeTo: titleLabel, padding: 10, width: 400, height: 200)

        descLabel.groupAndAlign(group: .horizontal, andAlign: .underCentered, views: [goodreadsButton, googleButton], relativeTo: descLabel, padding: 25, width: 200, height: 50)

    }

    lazy var titleLabel: UILabel = {
        let this = UILabel()
        this.text = "Your book, \(bookTitle ?? "") could not be found in any Library in NUS."
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.primary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()

    lazy var descLabel: UILabel = {
        let this = UILabel()
        this.text = "However, you may find it on other platforms:"
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()

    lazy var goodreadsButton: ZFRippleButton = {
        let this = ZFRippleButton()
        this.setTitle("Goodreads", for: .normal)
        this.setImage(UIImage(named: "goodreads-long"), for: .normal)
        this.imageEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        this.imageView?.contentMode = .scaleAspectFit
        this.backgroundColor = UIColor.goodreadsSocial
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(openBookInGoodReads), for: .touchUpInside)
        return this
    }()

    lazy var googleButton: ZFRippleButton = {
        let this = ZFRippleButton()
        this.setTitle("Google Books", for: .normal)
        this.setImage(UIImage(named: "google-long"), for: .normal)
        this.imageView?.contentMode = .scaleAspectFit
        this.imageEdgeInsets = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        this.backgroundColor = UIColor.googleSocial
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(openBookInGoogleBooks), for: .touchUpInside)
        return this
    }()

    @objc func openBookInGoogleBooks() {
        if let bookISBN = bookISBN {
            let urlString = "https://books.google.com.sg/books?vid=ISBN\(bookISBN)"

            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:])
            }
        }

        self.dismiss(animated: true)
    }

    @objc func openBookInGoodReads() {
        if let bookTitle = bookTitle {
            let query = bookTitle.replacingOccurrences(of: " ", with: "+")
            let urlString = "https://www.goodreads.com/search?q=\(query)"

            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:])
            }
        }

        self.dismiss(animated: true)
    }
}
