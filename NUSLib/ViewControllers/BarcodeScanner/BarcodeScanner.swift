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
//            .map{ $0.title}
//            .filterNil()
//            .takeWhile {!$0.isEmpty}
//            .flatMapLatest{ api.getBooks(byTitle: $0)}
            .subscribe(onNext: { (bookItem) in
                if bookItem.title == "" {
                    print("no result")
                } else {
                    print(bookItem)
                    
                    print("--------------------")
                    print(bookItem.title)
                    print(bookItem.author)
                    print("--------------------")

                    
                    self.state = StateController()
                    self.state?.itemDetail = bookItem
                }
            }, onCompleted: { () -> Void in
                print("completed")
                controller.reset()
                self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
            })
        
        
//                let bookFromISBN = api.getBook(byISBN: bookISBN)
//                    .subscribe(onNext: { (bookItem) in
//                        self.state?.itemDetail = bookItem
//                        self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
//                    })
//
//        
//                let bookFromISBN = api.getBook(byISBN: bookISBN)
//                    .map{ $0.title}
//                    .filterNil()
//                    .takeWhile {!$0.isEmpty}
//                    .flatMapLatest{ api.getBooks(byTitle: $0)}
//                    .subscribe(onNext: { (bookItems) in
//                        if bookItems.isEmpty {
//                            print("no result")
//                        } else {
//                            print(bookItems.first?.title)
//                        }
//                    }, onCompleted: { () -> Void in
//                        print("completed")
//                    })

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            controller.performSegue(withIdentifier: "BarcodeToBookNotFound", sender: self)
//            controller.reset()
//            controller.resetWithError(message: "No book found with ISBN: \(bookISBN)")
//        }
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

