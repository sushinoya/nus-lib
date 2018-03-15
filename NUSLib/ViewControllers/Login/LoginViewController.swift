//
//  ViewController.swift
//  NUSLib
//
//  Created by wongkf on 13/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import SkyFloatingLabelTextField
import FontAwesome_swift
import ZFRippleButton
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let texture = UIView()
    let logo = UIImageView()

    let studentId = SkyFloatingLabelTextFieldWithIcon()
    let studentPassword = SkyFloatingLabelTextFieldWithIcon()
    
    let loginButton = ZFRippleButton()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        texture.fillSuperview()
        
        // align in the center, then offset by 100px upwards
        logo.anchorInCenter(width: 300, height: 202)
        logo.frame = logo.frame.offsetBy(dx: 0, dy: -150)
        
        studentId.align(.underCentered, relativeTo: logo, padding: 15, width: 400, height: 50)
        studentPassword.align(.underCentered, relativeTo: studentId, padding: 15, width: 400, height: 50)
        
        loginButton.align(.underCentered, relativeTo: studentPassword, padding: 30, width: 200, height: 50)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor.primary
        
        view.addSubview(texture)
        texture.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "crissxcross"))
        
        view.addSubview(logo)
        logo.image = #imageLiteral(resourceName: "logo")
        
        view.addSubview(studentId)
        studentId.iconFont = UIFont.fontAwesome(ofSize: 15)
        studentId.iconText = String.fontAwesomeIcon(name: .idCard)
        studentId.autocapitalizationType = .allCharacters
        studentId.placeholder = "Matric Number"
        studentId.title = "Matric Number"
        studentId.tintColor = UIColor.white // the color of the blinking cursor
        studentId.textColor = UIColor.white
        studentId.lineColor = UIColor.white
        studentId.selectedTitleColor = UIColor.accent2
        studentId.selectedLineColor = UIColor.accent2
        studentId.delegate = self
        studentId.tag = 0
        
        view.addSubview(studentPassword)
        studentPassword.iconFont = UIFont.fontAwesome(ofSize: 15)
        studentPassword.iconText = String.fontAwesomeIcon(name: .lock)
        studentPassword.placeholder = "Password"
        studentPassword.title = "Password"
        studentPassword.textColor = UIColor.white
        studentPassword.lineColor = UIColor.white
        studentPassword.selectedTitleColor = UIColor.accent2
        studentPassword.selectedLineColor = UIColor.accent2
        studentPassword.isSecureTextEntry = true
        studentPassword.delegate = self
        studentPassword.tag = 1
        
        view.addSubview(loginButton)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.backgroundColor = UIColor.primaryTint1
        loginButton.layer.cornerRadius = 25
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.masksToBounds = false
        loginButton.rippleColor = UIColor.white.withAlphaComponent(0.2)
        loginButton.rippleBackgroundColor = UIColor.clear
        
        loginButton.rx.tap.bind {
            self.performSegue(withIdentifier: "loginSegue", sender: self.loginButton)
            }
            .disposed(by: disposeBag)
    }

}
