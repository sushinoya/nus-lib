//
//  ViewController.swift
//  NUSLib
//
//  Created by wongkf on 13/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class LoginViewController: UIViewController {
    
    let texture = UIView()
    let logo = UIImageView()
    
    let studentId = UITextField()
    let studentPassword = UITextField()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        texture.fillSuperview()
        
        // align in the center, then offset by 100px upwards
        logo.anchorInCenter(width: 300, height: 202)
        logo.frame = logo.frame.offsetBy(dx: 0, dy: -100)
        
        studentId.align(.underCentered, relativeTo: logo, padding: 15, width: 400, height: 50)
        studentPassword.align(.underCentered, relativeTo: studentId, padding: 15, width: 400, height: 50)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#092140")
        
        view.addSubview(texture)
        texture.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "crissxcross"))
        
        view.addSubview(logo)
        logo.image = #imageLiteral(resourceName: "logo")
        
        view.addSubview(studentId)
        studentId.placeholder = "Student ID"
        studentId.setLeftPaddingPoints(15)
        studentId.setRightPaddingPoints(15)
        studentId.layer.cornerRadius = 15
        studentId.layer.backgroundColor = UIColor.white.cgColor
        
        view.addSubview(studentPassword)
        studentPassword.placeholder = "Password"
        studentPassword.setLeftPaddingPoints(15)
        studentPassword.setRightPaddingPoints(15)
        studentPassword.layer.cornerRadius = 15
        studentPassword.layer.backgroundColor = UIColor.white.cgColor
        studentPassword.isSecureTextEntry = true
        
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

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
