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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        aboutTitle.center.x = self.view.center.x
//        aboutTitle.center.y = self.view.center.y
//
//        aboutTitle.alignAndFillWidth(align: .underCentered, relativeTo: self.view, padding: 50, height: 50)

        aboutTitle.anchorToEdge(.top, padding: 40, width: view.width, height: 25)
        
        developersTitle.alignAndFillWidth(align: .underCentered, relativeTo: aboutTitle, padding: 70, height: 25)

        developersDescription.align(.underCentered, relativeTo: developersTitle, padding: 10, width: view.width - 200, height: 150)
        
        libraryTitle.alignAndFillWidth(align: .underCentered, relativeTo: developersDescription, padding: 70, height: 25)
        
        libraryDescription.align(.underCentered, relativeTo: libraryTitle, padding: 10, width: view.width - 200, height: 150)
        
        sendFeedback.align(.underCentered, relativeTo: libraryDescription, padding: 50, width: 250, height: 50)

    }
    
    private func addSubviews(){
        self.view.addSubview(self.aboutTitle)
        self.view.addSubview(self.developersTitle)
        self.view.addSubview(self.developersDescription)
        self.view.addSubview(self.libraryTitle)
        self.view.addSubview(self.libraryDescription)
        self.view.addSubview(self.sendFeedback)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
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
        this.text = "Bacon ipsum dolor amet ribeye ham hock bacon, short ribs capicola t-bone meatloaf ham fatback ball tip cow drumstick cupim. Chuck capicola ground round biltong. Cow tail biltong tenderloin buffalo beef pork chop corned beef turkey ground round bacon shoulder chuck tri-tip ball tip. Short loin tail ham, pork loin shankle ribeye sirloin pig kielbasa. Porchetta rump pig kevin burgdoggen cow turducken filet mignon kielbasa."
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
    
    private(set) lazy var libraryDescription: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet ribeye ham hock bacon, short ribs capicola t-bone meatloaf ham fatback ball tip cow drumstick cupim. Chuck capicola ground round biltong. Cow tail biltong tenderloin buffalo beef pork chop corned beef turkey ground round bacon shoulder chuck tri-tip ball tip. Short loin tail ham, pork loin shankle ribeye sirloin pig kielbasa. Porchetta rump pig kevin burgdoggen cow turducken filet mignon kielbasa."
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.content
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
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
        
        return this
    }()
    
}

