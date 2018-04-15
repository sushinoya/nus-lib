//
//  BarcodeScanner.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 28/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import Foundation
import UIKit
import BarcodeScanner

// MARK: - BarcodeScannerCodeDelegate
extension HomeViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        let bookISBN = code
        
        // Make request to library API here.
        self.bookISBN = bookISBN
        print("ISBN: \(bookISBN)")
        print("Type: \(type)")
        
        let api: LibraryAPI = CentralLibrary()
        
        let bookFromISBN = api.getBook(byISBN: bookISBN)
        
        bookFromISBN.map({
            if let name = $0.title {
                self.api.getBooks(byTitle: name).do(onNext: {
                    if let item = $0.first {
                        self.state?.itemDetail = item
                        self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
                    } else {
                        self.bookTitle = name
                        self.performSegue(withIdentifier: "BarcodeToBookNotFound", sender: self)
                    }
                })
            } else {
                print("Title is nil")
                 controller.resetWithError(message: "No book found with ISBN: \(bookISBN)")

            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            controller.performSegue(withIdentifier: "BarcodeToBookNotFound", sender: self)
            controller.reset()
            // controller.resetWithError(message: "No book found with ISBN: \(bookISBN)")
        }
    }
    
}

// MARK: - BarcodeScannerErrorDelegate
extension HomeViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension HomeViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

