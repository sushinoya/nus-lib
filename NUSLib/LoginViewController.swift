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

class LoginViewController: UIViewController {

    let texture = UIView()
    let logo = UIImageView()

    let loginTitle = UILabel()

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

        view.backgroundColor = UIColor(Constants.Colors.backgroundColor)

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
        studentId.selectedTitleColor = UIColor(Constants.Colors.titleColor)
        studentId.selectedLineColor = UIColor(Constants.Colors.titleColor)
        studentId.delegate = self
        studentId.tag = 0

        view.addSubview(studentPassword)
        studentPassword.iconFont = UIFont.fontAwesome(ofSize: 15)
        studentPassword.iconText = String.fontAwesomeIcon(name: .lock)
        studentPassword.placeholder = "Password"
        studentPassword.title = "Password"
        studentPassword.textColor = UIColor.white
        studentPassword.lineColor = UIColor.white
        studentPassword.selectedTitleColor = UIColor(Constants.Colors.titleColor)
        studentPassword.selectedLineColor = UIColor(Constants.Colors.titleColor)
        studentPassword.isSecureTextEntry = true
        studentPassword.delegate = self
        studentPassword.tag = 1

        view.addSubview(loginButton)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.backgroundColor = UIColor("#213753")
        loginButton.layer.cornerRadius = 25
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.masksToBounds = false
        loginButton.rippleColor = UIColor.white.withAlphaComponent(0.2)
        loginButton.rippleBackgroundColor = UIColor.clear
    }

}

extension UIColor {
    convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
