//
//  FilterLauncher.swift
//  NUSLib
//
//  Created by Liang on 30/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

/*
 It defines a list of methods that suit the filter task
 */
protocol FilterLauncherDelegate: class {
    func filterByTitle(_ length: Int)
}

/*
 The controller manages the UI for Filter Page. Allowing user to perform filter by title length.
 */
class FilterLauncher: UIViewController {

    // MARK: - Variables
    let blackView = UIView()
    var y: CGFloat = 0
    weak var delegate: FilterLauncherDelegate?

    //Mark: - Setup Views
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

    // MARK: - Helper methods

    /*
     It set up views for Filter
     */
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
                self.titleLengthLabel.frame = CGRect(x: 20, y: 0, width: 120, height: titleLengthHeight)
                self.titleLengthTextField.frame = CGRect(x: 140, y: 0, width: self.baseView.width - 20, height: titleLengthHeight)
                self.submitButton.frame = CGRect(x: 0, y: 0 + titleLengthHeight, width: window.frame.width, height: buttonHeight)
            }, completion: nil)
        }

    }

    /*
     It dismiss the Filter page with an animation
     */
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.baseView.frame = CGRect(x: 0, y: window.frame.height, width: self.baseView.width, height: self.baseView.height)
                self.titleLengthLabel.frame = CGRect(x: 0, y: window.frame.height, width: 120, height: self.titleLengthLabel.height)
                self.titleLengthTextField.frame = CGRect(x: 120, y: window.frame.height, width: self.baseView.width, height: self.titleLengthTextField.height)
                self.submitButton.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.submitButton.height)
                self.titleLengthTextField.resignFirstResponder()
                self.baseView.removeFromSuperview()
                self.blackView.removeFromSuperview()
            }
        }
    }

    /*
     It shows the keyboard by moving the Filter page up when user taps onto filter textfield
     */
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

    /*
     It hide keyboard and move filter page to its original position
     */
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.baseView.frame = CGRect(x: 0, y: self.y, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }, completion: nil)
    }

    /*
     It will let its deletage handle the filter method and then removes filter page from view
     */
    @objc func handleSubmit() {
        var length = 1000
        if let text = titleLengthTextField.text {
            if text.isEmpty {
                length = 1000
            } else {
                length = Int(text)!
            }

        }
        delegate?.filterByTitle(length)
        baseView.removeFromSuperview()
        blackView.removeFromSuperview()
    }

}

//Mark: - UITextFieldDelegate
extension FilterLauncher: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}
