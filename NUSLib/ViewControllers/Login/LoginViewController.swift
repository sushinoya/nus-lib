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
    
    //MARK: - Variables
    var nameField: SkyFloatingLabelTextFieldWithIcon?
    var passwordField: SkyFloatingLabelTextFieldWithIcon?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()

        addSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.LoginTitle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        texture.fillSuperview()
        overlay.anchorInCenter(width: 500, height: 500)
        
        // align in the center, then offset by 100px upwards
        logo.anchorInCenter(width: 300, height: 202)
        logo.frame = logo.frame.offsetBy(dx: 0, dy: -150)

        //Student ID
        studentId.align(.underCentered, relativeTo: logo, padding: 15, width: 400, height: 50)
        
        //Student Password
        studentPassword.align(.underCentered, relativeTo: studentId, padding: 15, width: 400, height: 50)
        
        //Login button
        loginButton.align(.underCentered, relativeTo: studentPassword, padding: 30, width: 200, height: 50)
        
    }
    
    //MARK: - Lazy initionlization views
    private func addSubViews(){
        view.backgroundColor = UIColor.primary
        view.addSubview(texture)
        view.sendSubview(toBack: texture)
        view.addSubview(overlay)
        view.addSubview(logo)
        view.addSubview(studentId)
        view.addSubview(studentPassword)
        view.addSubview(loginButton)
    }
    
    lazy var texture: UIImageView = {
        let texture = UIImageView()
        texture.image = #imageLiteral(resourceName: "spashscreenv1")
        return texture
    }()
    
    lazy var overlay: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        let this = UIVisualEffectView(effect: effect)
        this.layer.cornerRadius = 25
        this.clipsToBounds = true
        this.alpha = 0.8
        
        return this
    }()
    
    lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "Library")
        logo.contentMode = .center
        return logo
    }()
    
    lazy var studentId: SkyFloatingLabelTextFieldWithIcon = { [unowned self] in
        let studentId = SkyFloatingLabelTextFieldWithIcon()
        studentId.iconFont = UIFont.fontAwesome(ofSize: 15)
        studentId.iconText = String.fontAwesomeIcon(name: .idCard)
        studentId.iconColor = UIColor.primaryTint1
        studentId.placeholder = "Matric Number"
        studentId.title = "Matric Number"
        studentId.tintColor = UIColor.primary // the color of the blinking cursor
        studentId.textColor = UIColor.primary
        studentId.lineColor = UIColor.primary
        studentId.selectedTitleColor = UIColor.primaryTint1
        studentId.selectedLineColor = UIColor.primaryTint1
        studentId.placeholderColor = UIColor.primaryTint1
        studentId.autocapitalizationType = .none
        studentId.tag = 0
        studentId.delegate = self
        nameField = studentId
        return studentId
    }()
    
    lazy var studentPassword: SkyFloatingLabelTextFieldWithIcon = { [unowned self] in
        let studentPassword = SkyFloatingLabelTextFieldWithIcon()
        studentPassword.iconFont = UIFont.fontAwesome(ofSize: 15)
        studentPassword.iconText = String.fontAwesomeIcon(name: .lock)
        studentPassword.iconColor = UIColor.primaryTint1
        studentPassword.placeholder = "Password"
        studentPassword.title = "Password"
        studentPassword.textColor = UIColor.primary
        studentPassword.lineColor = UIColor.primary
        studentPassword.selectedTitleColor = UIColor.primaryTint1
        studentPassword.selectedLineColor = UIColor.primaryTint1
        studentPassword.placeholderColor = UIColor.primaryTint1
        studentPassword.isSecureTextEntry = true
        studentPassword.tag = 1
        studentPassword.delegate = self
        passwordField = studentPassword
        return studentPassword
    }()
    
    lazy var loginButton: ZFRippleButton = {
        let loginButton = ZFRippleButton()
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
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        return loginButton
    }()

    //MARK: - Helper methods
    @objc func loginUser() {
        let username = nameField?.text?.lowercased()
        let password = passwordField?.text
        let ds: AppDataSource = FirebaseDataSource()
        ds.authenticateUser(email: username!, password: password!) { result in
            if let user = result {
                self.loginResult(0, name: user.getUsername())
            } else {
                self.loginResult(1, name: "fail")
            }
        }
    }

    func loginResult(_ result: Int, name: String) {
        let alert = UIAlertController(title: "RESULT",
                                      message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            if result == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        if result == 0 {
            alert.message = "Signed In. Welcome, \(name)"
        } else {
            alert.message = "Couldn't sign in"
        }
        self.present(alert, animated: true, completion: nil)
    }
}
