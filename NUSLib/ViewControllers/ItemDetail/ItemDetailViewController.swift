//
//  ItemDetailViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Kingfisher
import ZFRippleButton
import RxSwift
import RxCocoa
import FirebaseDatabase
import Firebase
import TwitterKit
import FacebookLogin
import FacebookCore
import FacebookShare

class ItemDetailViewController: BaseViewController {
    
    let bookCollectionViewCellID = "bookCollectionViewCell"
    let api: LibraryAPI = CentralLibrary()
    var similarTitleText: Variable<String> = Variable("")
    
    private(set) lazy var overlay: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor.primary
        return this
    }()
    
    private(set) lazy var previewImageShadow: UIView = { [unowned self] in
        let this = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 250, height: 417)))
        this.backgroundColor = UIColor.clear
        this.layer.cornerRadius = 20
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOpacity = 0.7
        this.layer.shadowOffset = CGSize.zero
        this.layer.shadowRadius = 5
        this.layer.shadowPath = UIBezierPath(roundedRect: this.frame, cornerRadius: 10).cgPath
        this.layer.shouldRasterize = true
        return this
    }()
    
    private(set) lazy var previewImage: UIImageView = {
        let this = UIImageView()
        this.kf.setImage(with: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg"),
                          options: [.transition(.fade(0.2))])
        this.contentMode = .scaleAspectFill
        this.clipsToBounds = false
        this.layer.cornerRadius = 20
        this.layer.masksToBounds = true
    
        return this
    }()
    
    private(set) lazy var previewTitle: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet flank shankle,  Ribeye shankle short loin."
        this.textColor = UIColor.white
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        
        if let itemDetail = state?.itemDetail {
            this.text = itemDetail.getTitle()
        }
        
        return this
    }()
    
    private(set) lazy var previewSubtitle: UILabel = {
        let this = UILabel()
        this.text = "by Drumstick Turducken"
        this.textColor = UIColor.gray
        this.textAlignment = .left
        this.font = UIFont.title
        return this
    }()
    
    private(set) lazy var location: UILabel = {
        let this = UILabel()
        this.text = "Located @ sausage frankfurter bacon"
        this.textColor = UIColor.white
        this.textAlignment = .left
        this.font = UIFont.subtitle
        return this
    }()
    
    private(set) lazy var favourite: ZFRippleButton = { [unowned self] in
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
        
        self.database.child("Favourites").observe(.value, with: { (snapshot) in
            let favourite = snapshot.value as? [String: AnyObject] ?? [:]
            
            let favouriteCount = favourite["dummy"] as? Int ?? 0
            
            this.setTitle("FAVOURITE (\(favouriteCount))", for: .normal)
            
        })

        if Auth.auth().currentUser != nil {
            //This can retrieve the current 'signed in' user, so no need to pass data using UserProfile
        } else {
            //No user signed in 
        }
        
        this.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { result in
                self.database.child("Favourites").runTransactionBlock({ (data) -> TransactionResult in
                    if var bibs = data.value as? [String: AnyObject] {
                        
                        var dummyVal = bibs["dummy"] as? Int ?? -1
                        
                        dummyVal += 1
                        
                        bibs["dummy"] = dummyVal as AnyObject?
                        
                        data.value = bibs
                    }
                    
                    return TransactionResult.success(withValue: data)
                }) { (error, committed, snapshot) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return this
    }()
    
    private(set) lazy var sypnosisTitle: UILabel = {
        let this = UILabel()
        this.text = "SYPNOSIS"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var sypnosisContent: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet ribeye ham hock bacon, short ribs capicola t-bone meatloaf ham fatback ball tip cow drumstick cupim. Chuck capicola ground round biltong. Cow tail biltong tenderloin buffalo beef pork chop corned beef turkey ground round bacon shoulder chuck tri-tip ball tip. Short loin tail ham, pork loin shankle ribeye sirloin pig kielbasa. Porchetta rump pig kevin burgdoggen cow turducken filet mignon kielbasa."
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.content
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var similarTitle: UILabel = {
        let this = UILabel()
        this.text = "SIMILAR MEDIA"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    
    private(set) lazy var similarCollection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 150)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 20)
        
        let this = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        this.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCollectionViewCellID)
        this.backgroundColor = UIColor.clear
        this.backgroundView = UIImageView(image: UIImage.fontAwesomeIcon(name: .spinner, textColor: UIColor.gray, size: CGSize(width: 64, height: 64)))
        this.backgroundView?.contentMode = .center
        this.showsHorizontalScrollIndicator = false
        return this
    }()
    
    
    private(set) lazy var facebookButton: SocialButton = { [unowned self] in
        let this = SocialButton(type: .facebook)
        this.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        return this
    }()
    
    private(set) lazy var twitterButton: SocialButton = { [unowned self] in
        let this = SocialButton(type: .twitter)
        this.addTarget(self, action: #selector(shareToTwitter), for: .touchUpInside)
        return this
    }()
    
    
    @objc func shareToFacebook() {
        print("To be implemented")
        
        let loginManager = LoginManager()
        
        if let accessToken = AccessToken.current {
            print("Already logged in")
            self.postToFaceBook()
//            loginManager.logOut()
            
            
        } else {
            loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (loginResult) in
                switch loginResult {
                case .failed(let error): print(error)
                case .cancelled: print("User cancelled login")
                case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
                    print("Logged in!")
                    self.postToFaceBook()
                }
            }
        }
        
        
    }
    
    @objc func shareToTwitter() {
        print("Twitter pressed")
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            let composer = TWTRComposerViewController.emptyComposer()
            present(composer, animated: true, completion: nil)
        } else {
            // Log in, and then check again
            TWTRTwitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    let composer = TWTRComposerViewController.emptyComposer()
                    self.present(composer, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    
    private func postToFaceBook() {
        let content = LinkShareContent(url: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover1.jpg")!, quote: "Title")
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
            print(result)
        }
        
        do {
            try shareDialog.show()
        } catch {
            print(error)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        overlay.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: view.bounds.height*2/5)
        previewImage.anchorInCorner(.topLeft, xPad: 50, yPad: 50, width: 250, height: 417)
        previewImageShadow.frame = previewImage.frame
        previewTitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: 25)
        previewTitle.sizeToFit()
        previewSubtitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: 25, offset: previewTitle.height)
        previewSubtitle.sizeToFit()
        location.alignAndFillWidth(align: .toTheRightCentered, relativeTo: previewImage, padding: 50, height: 25, offset: -50)
        favourite.align(.toTheRightCentered, relativeTo: previewImage, padding: 50, width: 250, height: 50, offset: 25)
        facebookButton.align(.toTheRightCentered, relativeTo: favourite, padding: 20, width: 50, height: 50, offset: 0)
        twitterButton.align(.toTheRightCentered, relativeTo: facebookButton, padding: 20, width: 50, height: 50, offset: 0)
        sypnosisTitle.alignAndFillWidth(align: .underCentered, relativeTo: overlay, padding: 0, height: 25, offset: 0)
        sypnosisTitle.frame = sypnosisTitle.frame.offsetBy(dx: 50, dy: 125)
        sypnosisContent.alignAndFillWidth(align: .underCentered, relativeTo: sypnosisTitle, padding: 50, height: 25)
        sypnosisContent.frame = sypnosisContent.frame.offsetBy(dx: 0, dy: -25)
        sypnosisContent.sizeToFit()
        similarCollection.anchorAndFillEdge(.bottom, xPad: 0, yPad: 20, otherSize: 180)
        similarTitle.alignAndFillWidth(align: .aboveCentered, relativeTo: similarCollection, padding: 0, height: 25)
        similarTitle.frame = similarTitle.frame.offsetBy(dx: 50, dy: -25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(overlay)
        view.addSubview(previewImageShadow)
        view.addSubview(previewImage)
        view.addSubview(previewTitle)
        view.addSubview(previewSubtitle)
        view.addSubview(location)
        view.addSubview(favourite)
        view.addSubview(sypnosisTitle)
        view.addSubview(sypnosisContent)
        view.addSubview(similarTitle)
        view.addSubview(similarCollection)
        view.addSubview(facebookButton)
        view.addSubview(twitterButton)

        setupSimilarBooks()
    }
    
    private func setupSimilarBooks() {
        similarTitleText.value =  "Title"
        
        similarTitleText.asObservable()
            .flatMapLatest { request -> Observable<[BookItem]> in
                return self.api.getBooksFromKeyword(keyword: request, limit: 10)
            }
            .bind(to: similarCollection.rx.items(cellIdentifier: bookCollectionViewCellID, cellType: BookCollectionViewCell.self)) {
                index, model, cell in
                cell.title.text = model.getTitle()
                cell.alpha = 0
                self.similarCollection.backgroundView = nil
                UIView.animate(withDuration: 0.5, animations: {
                    cell.alpha = 1
                })
            }
            .disposed(by: disposeBag)
        
        similarCollection.rx.modelSelected(BookItem.self).subscribe(onNext: { model in
            
            if let selectedRowIndexPath = self.similarCollection.indexPathsForSelectedItems {
                self.similarCollection.deselectItem(at: selectedRowIndexPath[0], animated: true)
            }

            self.previewTitle.text = model.getTitle()
            self.similarTitleText.value = String(model.getTitle().suffix(4))
            
        }).disposed(by: disposeBag)
    
    }
}



