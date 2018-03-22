//
//  UIViewController+DefaultConfig.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RxSwift
import RxCocoa
import RxGesture
import SideMenu

/**
 This class store default configuration & utility functions for application.
 All VCs should inherit this class so that default configuration is applied properly.
 Otherwise, VC should inherit from default UIViewController for customization.
 */
class BaseViewController: UIViewController{
    internal let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove black bar when side bar open
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        
        // transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    internal func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
