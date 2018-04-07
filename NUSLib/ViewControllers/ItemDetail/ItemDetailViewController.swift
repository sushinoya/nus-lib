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
import RxOptional
import FirebaseDatabase
import Firebase
import TwitterKit
import XCGLogger
import FacebookLogin
import FacebookCore
import FacebookShare
import NVActivityIndicatorView
import DCAnimationKit

class ItemDetailViewController: BaseViewController, UIScrollViewDelegate {
    
    let bookCollectionViewCellID = "bookCollectionViewCell"
    let api: LibraryAPI = CentralLibrary()
    var similarTitleText: Variable<String> = Variable("")
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loading.anchorInCenter(width: 100, height: 100)
        
        scrollView.fillSuperview()
        
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
        
        reviewTitle.alignAndFillWidth(align: .underCentered, relativeTo: sypnosisContent, padding: 50, height: 25)
        reviewTitle.sizeToFit()
        
        reviewButton.align(.toTheRightCentered, relativeTo: reviewTitle, padding: 15, width: 30, height: 30)
        
        reviewCollection.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 0, height: 200)
        reviewCollection.frame = reviewCollection.frame.offsetBy(dx: 0, dy: 25)
        
        similarTitle.alignAndFillWidth(align: .underCentered, relativeTo: reviewCollection, padding: 0, height: 25)
        similarTitle.frame = similarTitle.frame.offsetBy(dx: 50, dy: 25)
        
        similarCollection.alignAndFillWidth(align: .underCentered, relativeTo: similarTitle, padding: 0, height: 320)
        similarCollection.frame = similarCollection.frame.offsetBy(dx: 0, dy: 25)
        
        loadingSimilarCollection.align(.underCentered, relativeTo: similarTitle, padding: 0, width: 50, height: 50)
        loadingSimilarCollection.frame = loadingSimilarCollection.frame.offsetBy(dx: 0, dy: 50)
        
        googleRecommendationTitle.alignAndFillWidth(align: .underCentered, relativeTo: similarCollection, padding: 0, height: 25)
        googleRecommendationTitle.frame = googleRecommendationTitle.frame.offsetBy(dx: 50, dy: 25)
        
        googleRecommendationCollection.alignAndFillWidth(align: .underCentered, relativeTo: googleRecommendationTitle, padding: 0, height: 320)
        googleRecommendationCollection.frame = googleRecommendationCollection.frame.offsetBy(dx: 0, dy: 25)
        
        loadingGoogleRecommendation.align(.underCentered, relativeTo: googleRecommendationTitle, padding: 0, width: 50, height: 50)
        loadingGoogleRecommendation.frame = loadingGoogleRecommendation.frame.offsetBy(dx: 0, dy: 50)
        
        scrollView.fitToContent()
    }
    
    private func addSubviews(){
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.overlay)
        self.scrollView.addSubview(self.previewImageShadow)
        self.scrollView.addSubview(self.previewImage)
        self.scrollView.addSubview(self.previewTitle)
        self.scrollView.addSubview(self.previewSubtitle)
        self.scrollView.addSubview(self.location)
        self.scrollView.addSubview(self.favourite)
        self.scrollView.addSubview(self.sypnosisTitle)
        self.scrollView.addSubview(self.sypnosisContent)
        self.scrollView.addSubview(self.reviewTitle)
        self.scrollView.addSubview(self.reviewButton)
        self.scrollView.addSubview(self.reviewCollection)
        self.scrollView.addSubview(self.similarTitle)
        self.scrollView.addSubview(self.similarCollection)
        self.scrollView.addSubview(self.loadingSimilarCollection)
        self.scrollView.addSubview(self.googleRecommendationTitle)
        self.scrollView.addSubview(self.googleRecommendationCollection)
        self.scrollView.addSubview(self.loadingGoogleRecommendation)
        self.scrollView.addSubview(self.facebookButton)
        self.scrollView.addSubview(self.twitterButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loading)
        loading.startAnimating()
        
        // get the book by id
        let book = api.getBook(byId: "1000014")
            // add views and update labels after the book item is returned
            .do(onNext: { bookItem in
                self.addSubviews()
                
                self.setupSimilarMediaTapAction()
                
                self.loading.stopAnimating()
                self.scrollView.animateFadeIn()
                
                self.previewTitle.text = bookItem.title
                self.previewSubtitle.text = "by \(bookItem.author ?? "Unknown Author")"
                
                self.previewImageShadow.expand(into: self.scrollView, finished: nil)
                self.previewImage.expand(into: self.scrollView, finished: nil) },
                
                // showing the loading spinner notifying user it is going to load the similar media
                onCompleted: {
                    self.loadingSimilarCollection.startAnimating()
                    self.loadingGoogleRecommendation.startAnimating()
            })
            .share(replay: 1, scope: .forever)
            
        // send the api request to get books by same author
        book.flatMapLatest{ self.getSimilarMedia(byAuthor: $0.author ?? "Unknown Author") }
        
            // if the request produces any error, return empty array
            .catchErrorJustReturn([])
            
            // if no books are found, show no result message
            .do(onNext: { $0.isEmpty ? self.similarCollection.displayEmptyResult() : () },
                
            // stop the spinner
                onCompleted: { self.loadingSimilarCollection.stopAnimating() })
            
            // bind result to collection view
            .bind(to: self.similarCollection.rx.items(cellIdentifier: self.bookCollectionViewCellID, cellType: BookCollectionViewCell.self)) { index, model, cell in
                cell.title.text = model.title
                cell.subtitle.text = model.author
                cell.alpha = 0
                cell.animateFadeIn()
            }
            .disposed(by: disposeBag)
        
        book.flatMapLatest{ self.api.getBooksRecommendation(byTitle: $0.title ?? "") }
            // if the request produces any error, return empty array
            .catchErrorJustReturn([])
            
            // if no books are found, show no result message
            .do(onNext: { $0.isEmpty ? self.googleRecommendationCollection.displayEmptyResult() : () },
                
                // stop the spinner
                onCompleted: { self.loadingGoogleRecommendation.stopAnimating() })
            
            // bind result to collection view
            .bind(to: self.googleRecommendationCollection.rx.items(cellIdentifier: self.bookCollectionViewCellID, cellType: BookCollectionViewCell.self)) { index, model, cell in
                cell.title.text = model.title
                cell.subtitle.text = model.author
                cell.thumbnail.kf.setImage(with: model.thumbnail)
                cell.alpha = 0
                cell.animateFadeIn()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupSimilarMediaCollections() {
        
    }
    
    private func getSimilarMedia(byAuthor keyword: String) -> Observable<[BookItem]> {
        return Observable<String>
            .just(keyword)
            .flatMapLatest { self.api.getBooks(byAuthor: $0) }
    }
    
    private func chooseRandomWord(fromSentence sentence: String) -> String {
        let keywords = sentence.components(separatedBy: " ")
        
        let randomIndex = Int(arc4random_uniform(UInt32(keywords.count)))
        
        return keywords[randomIndex]
    }
    
    private func setupSimilarMediaTapAction() {
        similarCollection.rx.modelSelected(BookItem.self)
            .subscribe(onNext: { model in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "itemDetail") as! ItemDetailViewController
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
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
    
    /**********/
    /*   UI   */
    /**********/
    
    private(set) lazy var loading: NVActivityIndicatorView = {
        let this = NVActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)), type: .ballGridPulse, color: UIColor.primary, padding: 0)
        return this
    }()
    
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
            this.text = itemDetail.title
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
        
        let ds = FirebaseDataSource()
        
        let bookid = String(Int(arc4random_uniform(10) + 1000001))
        let ref = database.child("FavouritesCount").child("\(bookid)")

        ref.observe(.value, with: { (snapshot) in
            let favourite = snapshot.value as? [String : AnyObject] ?? [:]
            let favouriteCount = favourite["count"] as? Int ?? 0
            if snapshot.exists() {
                this.setTitle("FAVOURITE (\(favouriteCount))", for: .normal)
            } else {
                ref.child("count").setValue(favouriteCount)
            }
        })
        
        if let user = ds.getCurrentUser() {
            let uid = user.getUserID()
            
            var isMarked = false
            
            ds.getFavourite(by: uid, bookid: bookid, completionHandler: { (isMarked) in
                if isMarked {
                    this.backgroundColor = UIColor.blue
                } 
                
            })
            
            this.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { result in
                    
                    ds.addToFavourite(by: uid, bookid: bookid, bookTitle: "CS3217"){ isSuccess in
                        
                        if isSuccess {
                            self.updateCount(bookid: bookid, value: 1)
                            this.backgroundColor = UIColor.blue
                        } else {
                            ds.deleteFavourite(by: uid, bookid: bookid, completionHandler: {
                                self.updateCount(bookid: bookid, value: -1)
                                this.backgroundColor = UIColor.primaryTint1
                            })
                        }
                    }
                })
                .disposed(by: disposeBag)
        } else {
            
            this.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { result in
                    let alert = UIAlertController(title: "Favourite", message: "You must log in before adding to your favourite list.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: false, completion: nil)
            })
        }
        
        return this
        }()
    
    func updateCount(bookid: String, value: Int) {
        self.database.child("FavouritesCount").child("\(bookid)").runTransactionBlock({ (data) -> TransactionResult in
            if var bibs = data.value as? [String: AnyObject] {
                
                var dummyVal = bibs["count"] as? Int ?? 0
                
                dummyVal = dummyVal + value
                
                bibs["count"] = dummyVal as AnyObject?
                
                data.value = bibs
            }
            
            return TransactionResult.success(withValue: data)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    private(set) lazy var reviewTitle: UILabel = {
        let this = UILabel()
        this.text = "REVIEWS"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var reviewButton: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setImage(UIImage.fontAwesomeIcon(name: .plus, textColor: .white, size: CGSize(width: 25, height: 25)), for: .normal)
        this.imageView?.contentMode = .center
        this.backgroundColor = .primaryTint1
        this.layer.cornerRadius = 15
        this.layer.shadowColor = UIColor.black.cgColor
        this.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        this.layer.shadowRadius = 10
        this.layer.shadowOpacity = 0.5
        this.layer.masksToBounds = false
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        
        this.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                //self.performSegue(withIdentifier: "ItemDetailToPostReview", sender: self)
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "PostReviewController")
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController?.sourceView = this
                vc.popoverPresentationController?.sourceRect = this.frame
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return this
    }()
    
    private(set) lazy var reviewCollection: HorizontalCollectionView<ReviewCell> = {
        let this = HorizontalCollectionView<ReviewCell>(frame: view.bounds, cellCount: 5, cellSize: CGSize(width: 350, height: 200), cellSpacing: 25, sectionPadding: UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 0), data: nil, onDequeue: nil)
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        return this
    }()
    
    private(set) lazy var similarTitle: UILabel = {
        let this = UILabel()
        this.text = "SIMILAR MEDIA BY THIS AUTHOR"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var loadingSimilarCollection: NVActivityIndicatorView = {
        let this = NVActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)), type: .lineScale, color: UIColor.primary, padding: 0)
        return this
    }()
    
    private(set) lazy var similarCollection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 20)
        
        let this = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        this.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCollectionViewCellID)
        this.backgroundColor = UIColor.clear
        this.showsHorizontalScrollIndicator = false
        
        return this
    }()
    
    private(set) lazy var googleRecommendationTitle: UILabel = {
        let this = UILabel()
        this.text = "GOOGLE RECOMMENDATION"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var loadingGoogleRecommendation: NVActivityIndicatorView = {
        let this = NVActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)), type: .lineScale, color: UIColor.primary, padding: 0)
        return this
    }()
    
    private(set) lazy var googleRecommendationCollection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 20)
        
        let this = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        this.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCollectionViewCellID)
        this.backgroundColor = UIColor.clear
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
}



