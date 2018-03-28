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

extension BaseViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barcodeScannerVC = segue.destination as? BarcodeScannerViewController {
            barcodeScannerVC.codeDelegate = self
            barcodeScannerVC.errorDelegate = self
            barcodeScannerVC.dismissalDelegate = self
            barcodeScannerVC.title = "Scan a book"
        }
    }
}

// MARK: - BarcodeScannerCodeDelegate
extension BaseViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            controller.resetWithError()
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate
extension BaseViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension BaseViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


