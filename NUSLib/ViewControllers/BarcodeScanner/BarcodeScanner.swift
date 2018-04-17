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
        
        print("ISBN: \(bookISBN)")
        print("Type: \(type)")
        
        // If not a valid ISBN barcode
        if type != "org.gs1.EAN-13" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                controller.resetWithError(message: "No book found with ISBN: \(bookISBN)")
            }
        } else {
            let api: LibraryAPI = CentralLibrary()
            let bookFromISBN = api.getBook(byISBN: bookISBN)
            .subscribe(onNext: { (bookItem) in
                self.scannedBookTitle = bookItem.title
                self.scannedBookISBN = bookISBN

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.performSegue(withIdentifier: "HomeToBookNotFound", sender: self)
                    controller.reset()
                }
            })
        }
        
        
// TO BE CLEARED AFTER STePS with the proper implementation for querying the Google and Sierra API
        
//        let bookFromISBN = api.getBook(byISBN: bookISBN)
//            .takeWhile {$0.title != ""}
////            .flatMapLatest{ api.getBooks(byTitle: $0)}
//            .subscribe(onNext: { (bookItem) in
//                if bookItem.title == "" {
//                    print("no result")
//                    controller.resetWithError(message: "No book found with ISBN: \(bookISBN)")
//                } else {
//                    print(bookItem.title)
//                    print(bookItem.author)
//
//                    print("--------------------")
//                    print(bookItem.title)
//                    print(bookItem.author)
//                    print("--------------------")
//
//
//                    self.scannedBookTitle = bookItem.title
//                    self.scannedBookISBN = bookISBN
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                        self.performSegue(withIdentifier: "HomeToBookNotFound", sender: self)
//                        controller.reset()
//                    }
//
//                }
//            }, onCompleted: { () -> Void in
//                print("completed")
//            })
        
        
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

