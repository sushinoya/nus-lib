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
