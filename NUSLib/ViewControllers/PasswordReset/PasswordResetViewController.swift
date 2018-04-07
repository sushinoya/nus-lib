//
//  PasswordResetViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 8/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import SkyFloatingLabelTextField
import FontAwesome_swift
import ZFRippleButton
import RxSwift
import RxCocoa

class PasswordResetViewController: BaseViewController, UITextFieldDelegate {
    var currentPasswordField: SkyFloatingLabelTextFieldWithIcon?
    var newPasswordField: SkyFloatingLabelTextFieldWithIcon?
    var newPasswordFieldRetyped: SkyFloatingLabelTextFieldWithIcon?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        titleLabel.anchorInCenter(width: 300, height: 50)
        titleLabel.center.y -= 150
        
        currentPassword.align(.underCentered, relativeTo: titleLabel, padding: 40, width: 300, height: 50)
        newPassword.align(.underCentered, relativeTo: currentPassword, padding: 15, width: 300, height: 50)
        newPasswordRetyped.align(.underCentered, relativeTo: newPassword, padding: 15, width: 300, height: 50)
        resetButton.align(.underCentered, relativeTo: newPasswordRetyped, padding: 50, width: 200, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(currentPassword)
        view.addSubview(newPassword)
        view.addSubview(newPasswordRetyped)
        view.addSubview(resetButton)
        view.addSubview(titleLabel)
        
        self.currentPasswordField = currentPassword
        self.newPasswordField = newPassword
        self.newPasswordFieldRetyped = newPasswordRetyped
        
        currentPassword.delegate = self
        newPassword.delegate = self
        newPasswordRetyped.delegate = self
    }
    
    lazy var titleLabel: UILabel = {
        let this = UILabel()
        this.text = "RESET PASSWORD"
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    
    lazy var currentPassword: SkyFloatingLabelTextFieldWithIcon = {
        let this = SkyFloatingLabelTextFieldWithIcon()
        this.iconFont = UIFont.fontAwesome(ofSize: 15)
        this.iconText = String.fontAwesomeIcon(name: .lock)
        this.placeholder = "Current Password"
        this.title = "Current Password"
        this.textColor = UIColor.accent1
        this.lineColor = UIColor.accent1
        this.selectedTitleColor = UIColor.accent2
        this.selectedLineColor = UIColor.accent2
        this.isSecureTextEntry = true
        this.tag = 0
        return this
    }()
    
    lazy var newPassword: SkyFloatingLabelTextFieldWithIcon = {
        let this = SkyFloatingLabelTextFieldWithIcon()
        this.iconFont = UIFont.fontAwesome(ofSize: 15)
        this.iconText = String.fontAwesomeIcon(name: .lock)
        this.placeholder = "New Password"
        this.title = "New Password"
        this.textColor = UIColor.accent1
        this.lineColor = UIColor.accent1
        this.selectedTitleColor = UIColor.accent2
        this.selectedLineColor = UIColor.accent2
        this.isSecureTextEntry = true
        this.tag = 1
        return this
    }()
    
    lazy var newPasswordRetyped: SkyFloatingLabelTextFieldWithIcon = {
        let this = SkyFloatingLabelTextFieldWithIcon()
        this.iconFont = UIFont.fontAwesome(ofSize: 15)
        this.iconText = String.fontAwesomeIcon(name: .lock)
        this.placeholder = "Re-type New Password"
        this.title = "Re-type New Password"
        this.textColor = UIColor.accent1
        this.lineColor = UIColor.accent1
        this.selectedTitleColor = UIColor.accent2
        this.selectedLineColor = UIColor.accent2
        this.isSecureTextEntry = true
        this.tag = 2
        return this
    }()
    
    lazy var resetButton: ZFRippleButton = {
        let this = ZFRippleButton()
        this.setTitle("Reset Password", for: .normal)
        this.backgroundColor = UIColor.primaryTint1
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(resetUserPassword), for: .touchUpInside)
        return this
    }()
    
    @objc func resetUserPassword() {
        let currentPassword = currentPasswordField?.text
        let newPassword = newPasswordField?.text
        let newPasswordRetyped = newPasswordFieldRetyped?.text
        
        if newPassword == newPasswordRetyped {
            
            // Reset password here
            
        }
        
        self.dismiss(animated: true) {
            
        }
    }
}
