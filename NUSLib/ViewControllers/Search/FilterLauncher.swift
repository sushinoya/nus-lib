//
//  FilterLauncher.swift
//  NUSLib
//
//  Created by Liang on 30/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon


protocol FilterLauncherDelegate: class {
    func update(text: Int)
}


//Prevent Fat Controller:
//Instead of putting all the code inside SearchViewController, we should separate into a different class. Because displaying Filter Screen is not the job for SearchViewController

class FilterLauncher: UIViewController {
    
    let blackView = UIView()
    
    let baseView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let titleLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "Title length"
        return label
    }()
    
    let titleLengthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter max title length"
        textField.keyboardType = .numberPad
        textField.font = .systemFont(ofSize: 24)
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filter Now", for: .normal)
        return button
    }()
    
    
    var y: CGFloat = 0
    weak var delegate: FilterLauncherDelegate?
    
    func showFilters() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if let window = UIApplication.shared.keyWindow {
            
            //blackView
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            blackView.alpha = 0
            
            //baseView
            let baseViewHeight: CGFloat = 400
            y = window.frame.height - baseViewHeight
            baseView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: baseViewHeight)
            
            //label
            let titleLengthHeight: CGFloat = 40
            titleLengthLabel.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: titleLengthHeight)
            
            //textField
            titleLengthTextField.delegate = self
            titleLengthTextField.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: titleLengthHeight)
            
            //button
            let buttonHeight: CGFloat = 40
            submitButton.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: buttonHeight)
            
            window.addSubview(blackView)
            window.addSubview(baseView)
            baseView.addSubview(titleLengthLabel)
            baseView.addSubview(titleLengthTextField)
            baseView.addSubview(submitButton)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.baseView.frame = CGRect(x: 0, y: self.y, width: self.baseView.width, height: baseViewHeight)
                self.titleLengthLabel.frame = CGRect(x: 0, y: 0, width: 120, height: titleLengthHeight)
                self.titleLengthTextField.frame = CGRect(x: 120, y: 0, width: self.baseView.width, height: titleLengthHeight)
                self.submitButton.frame = CGRect(x: 0, y: 0 + titleLengthHeight, width: window.frame.width, height: buttonHeight)
            }, completion: nil)
        }
        
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.baseView.frame = CGRect(x: 0, y: window.frame.height, width: self.baseView.width, height: self.baseView.height)
                self.titleLengthLabel.frame = CGRect(x: 0, y: window.frame.height, width: 120, height: self.titleLengthLabel.height)
                self.titleLengthTextField.frame = CGRect(x: 120, y: window.frame.height, width: self.baseView.width, height: self.titleLengthTextField.height)
                self.submitButton.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.submitButton.height)
                self.titleLengthTextField.resignFirstResponder()
            }
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.baseView.frame = CGRect(x: 0, y: self.y - keyboardHeight, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.baseView.frame = CGRect(x: 0, y: self.y, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }, completion: nil)
    }
    
    @objc func handleSubmit() {
        var length = 100
        if let text = titleLengthTextField.text {
            if text.isEmpty {
                length = 100
            } else {
                length = Int(text)!
            }
           
        }
        delegate?.update(text: length)
        baseView.removeFromSuperview()
        blackView.removeFromSuperview()
        
    }
    
}

extension FilterLauncher: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}
