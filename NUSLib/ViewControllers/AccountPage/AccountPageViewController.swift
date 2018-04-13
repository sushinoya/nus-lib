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

class AccountPageViewController: BaseViewController, UIScrollViewDelegate {
    
    // Constants
    let profilePicDiameter: CGFloat = 140
    let overlayHeightFraction: CGFloat = 3/20
    
    //MARK: - Variables
    let user = FirebaseDataSource().getCurrentUser()
    let menuList = ["Username", "Email"]
    let menuCellIdentifier = "AccountMenuCell"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubviews()
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.AccountTitle
    }
    
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
        infoTable.alignAndFillWidth(align: .underMatchingLeft, relativeTo: nameLabel, padding: 0, height: 100)
        
        // Your Reviews
        reviewTitle.alignAndFillWidth(align: .underMatchingLeft, relativeTo: infoTable, padding: 0, height: 10, offset: 15)
        reviewTitle.sizeToFit()
        
        reviewCollection.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 0, height: 200)
        reviewCollection.frame = reviewCollection.frame.offsetBy(dx: 0, dy: 25)

        // Account settings buttons
        
        reviewCollection.groupAndAlign(group: .horizontal, andAlign: .underCentered, views: [resetPassword, logoutAccount], relativeTo: reviewCollection, padding: 25, width: 200, height: 50)

        scrollView.fitToContent()
    }
    
    //MARK: - Lazy initionlization views
    private func addSubviews(){
        self.view.addSubview(self.scrollView)

        self.scrollView.addSubview(self.overlay)
        self.scrollView.addSubview(self.profilePicture)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.reviewTitle)
        self.scrollView.addSubview(self.reviewCollection)
        self.scrollView.addSubview(self.infoTable)
        self.scrollView.addSubview(self.resetPassword)
        self.scrollView.addSubview(self.logoutAccount)
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
        this.layer.borderColor = UIColor.primaryTint1.cgColor

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
        let this = HorizontalCollectionView<UserReviewCell> {
            $0.cellSize = CGSize(width: 350, height: 200)
            $0.cellSpacing = 25
            $0.sectionPadding =  UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 0)
        }
        
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        return this
    }()
    
    
    private(set) lazy var infoTable: UITableView = {
        let this = UITableView(frame: .zero, style: UITableViewStyle.plain)
        this.dataSource = self
        this.delegate = self
        this.tableFooterView = UIView(frame: .zero)
        this.tableFooterView?.isHidden = true
        this.register(UITableViewCell.self, forCellReuseIdentifier: menuCellIdentifier)
        return this
    }()
    
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

    
    private(set) lazy var logoutAccount: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.backgroundColor = UIColor.accent1
        this.layer.cornerRadius = 25
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        this.addTarget(self, action: #selector(logoutAccountHandler), for: .touchUpInside)
        this.setTitle("Logout", for: .normal)
        
        return this
        }()
    
    
    //MARK: - Helper methods
    @objc func resetPasswordHandler() {
        performSegue(withIdentifier: "AccountToPasswordReset", sender: self)
    }
    
    @objc func logoutAccountHandler() {
        
        let alert = UIAlertController(title: "Confirm",
                                      message: "Are you sure you want to logout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            FirebaseDataSource().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
       
    }
}

//Mark: - UITableViewDelegate and UITableViewDataSource
extension AccountPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userAttributes = [user?.getUsername(), user?.getEmail()]
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: menuCellIdentifier)
        
        cell.textLabel?.text = menuList[indexPath.row]
        
        cell.detailTextLabel?.text = userAttributes[indexPath.row]
        cell.detailTextLabel?.textAlignment = .right
        
        return cell
    }
}
