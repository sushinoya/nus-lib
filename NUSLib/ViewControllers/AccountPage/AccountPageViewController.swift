//
//  AccountPageViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import ZFRippleButton
import FirebaseDatabase
import NVActivityIndicatorView



class AccountPageViewController: BaseViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Constants
    let profilePicDiameter: CGFloat = 140
    let overlayHeightFraction: CGFloat = 3/20
    let user = FirebaseDataSource().getCurrentUser()
    let menuList = ["Username", "Email"]
    let menuCellIdentifier = "AccountMenuCell"
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.fillSuperview()
        let overlayHeight = view.bounds.height * overlayHeightFraction
        let buttonPadding =  view.frame.width / 7

        // Banner
        overlay.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: overlayHeight)
        view.sendSubview(toBack: overlay)
        
        // Name and profile picture
        profilePicture.anchorToEdge(.top, padding: overlayHeight - profilePicDiameter / 2, width: profilePicDiameter, height: profilePicDiameter)

        nameLabel.alignAndFillWidth(align: .underCentered, relativeTo: profilePicture, padding: 15, height: 30)

        // Information Table
        infoTable.alignAndFillWidth(align: .underCentered, relativeTo: nameLabel, padding: 0, height: 200)
        infoTable.frame = infoTable.frame.offsetBy(dx: 0, dy: 25)
        
        // Your Reviews
        reviewTitle.alignAndFillWidth(align: .underCentered, relativeTo: infoTable, padding: 50, height: 25)
        reviewTitle.sizeToFit()
        
        reviewCollection.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 0, height: 200)
        reviewCollection.frame = reviewCollection.frame.offsetBy(dx: 0, dy: 25)

        // Account settings buttons
        resetPassword.anchorToEdge(.left, padding: buttonPadding, width: 250, height: 50)
        deleteAccount.anchorToEdge(.right, padding: buttonPadding, width: 250, height: 50)
        resetPassword.center.y = reviewCollection.yMax + 80
        deleteAccount.center.y = reviewCollection.yMax + 80

        scrollView.fitToContent()
    }
    
    private func addSubviews(){
        self.view.addSubview(self.scrollView)

        self.scrollView.addSubview(self.overlay)
        self.scrollView.addSubview(self.profilePicture)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.reviewTitle)
        self.scrollView.addSubview(self.reviewCollection)
        self.scrollView.addSubview(self.infoTable)
        self.scrollView.addSubview(self.resetPassword)
        self.scrollView.addSubview(self.deleteAccount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
    }
    
    private(set) lazy var scrollView: UIScrollView = { [unowned self] in
        let this = UIScrollView(frame: view.bounds)
        this.showsHorizontalScrollIndicator = false
        this.delegate = self
        return this
    }()
    
    private(set) lazy var overlay: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor.primary
        return this
    }()
    
    private(set) lazy var profilePicture: UIImageView = {
        let this = UIImageView()
        this.image = UIImage(named: "contact")
        this.backgroundColor = .white
        this.contentMode = .scaleAspectFill
        this.layer.cornerRadius = profilePicDiameter / 2
        this.layer.masksToBounds = true
        this.layer.borderWidth = 3
        this.layer.borderColor = UIColor.black.cgColor

        return this
    }()
    
    
    private(set) lazy var nameLabel: UILabel = {
        let this = UILabel()
        //        this.text = user?.getUsername()
        this.text = user?.getUsername()
        this.textColor = UIColor.primary
        this.textAlignment = .center
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var reviewTitle: UILabel = {
        let this = UILabel()
        this.text = "YOUR REVIEWS"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var reviewCollection: HorizontalCollectionView<UserReviewCell> = {
        let this = HorizontalCollectionView<UserReviewCell>(frame: view.bounds, cellCount: 5, cellSize: CGSize(width: 350, height: 200), cellSpacing: 25, sectionPadding: UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 0), data: nil, onDequeue: nil)
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        return this
    }()
    
    
    private(set) lazy var infoTable: UITableView = {
        let this = UITableView()
        this.dataSource = self
        this.delegate = self
        this.tableFooterView = UIView(frame: .zero)
        this.tableFooterView?.isHidden = true
        this.register(UITableViewCell.self, forCellReuseIdentifier: menuCellIdentifier)
        return this
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userAttributes = [user?.getUsername(), user?.getEmail()]
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier, for: indexPath)
        guard let textLabel = cell.textLabel else {
            return cell
        }

        textLabel.text = menuList[indexPath.row]
        textLabel.backgroundColor = .red
        
        let attributeValuelabel: UILabel = {
            let this = UILabel()
            this.text = userAttributes[indexPath.row]
            this.textColor = UIColor.gray
            this.textAlignment = .right
            this.lineBreakMode = .byWordWrapping
            this.numberOfLines = 0
            return this
        }()

        cell.contentView.addSubview(attributeValuelabel)
        attributeValuelabel.anchorToEdge(.right, padding: 0, width: 100, height: cell.height)
        
        return cell
    }
    
    
    private(set) lazy var resetPassword: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setTitle("FAVOURITE (0)", for: .normal)
        this.backgroundColor = UIColor.primaryTint1
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(resetPasswordHandler), for: .touchUpInside)
        this.setTitle("Reset Password", for: .normal)
        
        return this
    }()
    
    @objc func resetPasswordHandler() {
        performSegue(withIdentifier: "AccountToPasswordReset", sender: self)
    }
    
    
    private(set) lazy var deleteAccount: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setTitle("FAVOURITE (0)", for: .normal)
        this.backgroundColor = UIColor.accent4
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(deleteAccountHandler), for: .touchUpInside)
        this.setTitle("Reset Account", for: .normal)
        
        return this
    }()
    
    @objc func deleteAccountHandler() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "This action is irreversible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
            // Delete Account Implementation here
            
            return
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

