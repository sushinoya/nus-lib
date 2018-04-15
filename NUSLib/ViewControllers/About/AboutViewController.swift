//
//  AboutViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import ZFRippleButton

class AboutViewController: BaseViewController {
    
    //MARK: - Variables
    let datasource: AppDataSource = FirebaseDataSource()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubviews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.AboutTitle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        //About Title
        aboutTitle.anchorToEdge(.top, padding: 40, width: view.width, height: 25)
        
        //Developer
        developersTitle.alignAndFillWidth(align: .underCentered, relativeTo: aboutTitle, padding: 70, height: 25)
        developersDescription.align(.underCentered, relativeTo: developersTitle, padding: 10, width: view.width - 200, height: 150)
        
        //Library
        libraryTitle.alignAndFillWidth(align: .underCentered, relativeTo: developersDescription, padding: 70, height: 25)
        libraryDescription.align(.underCentered, relativeTo: libraryTitle, padding: 10, width: view.width - 200, height: 200)
        
        //Feedback Button
        sendFeedback.align(.underCentered, relativeTo: libraryDescription, padding: 50, width: 250, height: 50)

    }
    
    //MARK: - Lazy initialisation views
    private func addSubviews(){
        view.addSubview(aboutTitle)
        view.addSubview(developersTitle)
        view.addSubview(developersDescription)
        view.addSubview(libraryTitle)
        view.addSubview(libraryDescription)
        view.addSubview(sendFeedback)
    }


    private(set) lazy var aboutTitle: UILabel = {
        let this = UILabel()
        this.text = "ABOUT US"
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    
    private(set) lazy var developersTitle: UILabel = {
        let this = UILabel()
        this.text = "DEVELOPERS"
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var developersDescription: UILabel = {
        let this = UILabel()
        this.text = "CS3217 TEAM Hyena \n"
                + "Cao Liang @https://github.com/caoliangnus\n"
                + "Kang Fei @https://github.com/kfwong\n"
                + "Ram @https://github.com/ramjanarthan\n"
                + "Suyash @https://github.com/sushinoya"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.content
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var libraryTitle: UILabel = {
        let this = UILabel()
        this.text = "NUS LIBRARY"
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var libraryDescription: UITextView = {
        let this = UITextView()
        this.text = "Central Library is a multi-disciplinary library serving all NUS staff and students and primarily those from the Faculty of Arts and Social Sciences, the Faculty of Engineering, the School of Computing and the School of Design and Environment.\n" + "Opening Hours \n" +
            "Monday to Friday : 8.30am to 7pm \n" +
            "Saturday: 10am to 5pm \n" +
            "Sunday & Public Holidays: Closed"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.content
        this.isEditable = false
        return this
    }()
    
    private(set) lazy var sendFeedback: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setTitle("Send Feedback", for: .normal)
        this.backgroundColor = UIColor.primaryTint1
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        
        return this
    }()
    
    //MARK: - Helper methods
    @objc func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Feedback details", message: "Enter your feedback", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            guard let userId = self.datasource.getCurrentUser()?.getUserID() else {
                return
            }
            
            //getting the input values from user
            if let feedback = alertController.textFields?[0].text {
                self.datasource.addFeedback(by: userId, feedback: feedback)
            }

        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Feedback"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
}

