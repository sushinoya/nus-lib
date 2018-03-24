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

class LoginViewController: BaseViewController {
    
    let texture: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "crissxcross"))
        return this
    }()
    
    let logo: UIImageView = {
        let this = UIImageView()
        this.image = #imageLiteral(resourceName: "logo")
        return this
    }()
    
    let studentId: SkyFloatingLabelTextFieldWithIcon = {
        let this = SkyFloatingLabelTextFieldWithIcon()
        this.iconFont = UIFont.fontAwesome(ofSize: 15)
        this.iconText = String.fontAwesomeIcon(name: .idCard)
        this.autocapitalizationType = .allCharacters
        this.placeholder = "Matric Number"
        this.title = "Matric Number"
        this.tintColor = UIColor.white // the color of the blinking cursor
        this.textColor = UIColor.white
        this.lineColor = UIColor.white
        this.selectedTitleColor = UIColor.accent2
        this.selectedLineColor = UIColor.accent2
        this.tag = 0
        return this
    }()
    
    let studentPassword: SkyFloatingLabelTextFieldWithIcon = {
        let this = SkyFloatingLabelTextFieldWithIcon()
        this.iconFont = UIFont.fontAwesome(ofSize: 15)
        this.iconText = String.fontAwesomeIcon(name: .lock)
        this.placeholder = "Password"
        this.title = "Password"
        this.textColor = UIColor.white
        this.lineColor = UIColor.white
        this.selectedTitleColor = UIColor.accent2
        this.selectedLineColor = UIColor.accent2
        this.isSecureTextEntry = true
        this.tag = 1
        return this
    }()
    
    let loginButton: ZFRippleButton = {
        let this = ZFRippleButton()
        this.setTitle("LOGIN", for: .normal)
        this.backgroundColor = UIColor.primaryTint1
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        return this
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = UIColor.primary
        view.sendSubview(toBack: texture)

        view.addSubview(texture)
        view.addSubview(studentId)
        view.addSubview(studentPassword)
        view.addSubview(loginButton)
        setupNavigationBar()
        
        studentId.delegate = self
        studentPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
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
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.LoginTitle
    }
}
