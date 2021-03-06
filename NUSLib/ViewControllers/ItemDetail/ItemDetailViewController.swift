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

    // MARK: - Variables
    let defaultBookId = "1000002"
    let unknownTitle = "Unknown Title"
    let unknownAuthor = "Unknown Author"
    let unknownLocation = "Unknown Location"
    let bookCollectionViewCellID = "bookCollectionViewCell"
    lazy var bookId: String = state?.itemDetail?.id ?? defaultBookId
    lazy var bookTitle: String = state?.itemDetail?.title ?? unknownTitle
    let api: LibraryAPI = CentralLibrary()
    var similarTitleText: Variable<String> = Variable("")
    let datasource: AppDataSource = FirebaseDataSource()
    lazy var dbFavouriteCount = database.child("FavouritesCount").child(bookId)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupData()
        
    }
    
    private func setupGestures(){
        setupSimilarMediaTapAction()
        setupRecommendTapAction()
        
        if let uid = datasource.getCurrentUser()?.getUserID() {
            setupValidReviewTapAction(uid)
            checkHasFavourited(uid)
            setupValidFavouriteTapAction(uid)
        } else {
            setupInvalidReviewTapAction()
            setupInvalidFavouriteTapAction()
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.ItemDetailTitle
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        loading.anchorInCenter(width: 100, height: 100)

        scrollView.fillSuperview()

        overlay.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: view.bounds.height*2/5)
        previewImage.anchorInCorner(.topLeft, xPad: 50, yPad: 50, width: 250, height: 417)
        previewImageShadow.frame = previewImage.frame

        //Preview Title
        previewTitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: previewTitle.height)

        //PreviewSubtitle
        previewSubtitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: 25, offset: previewTitle.height)
        previewSubtitle.sizeToFit()

        //Location
        location.alignAndFillWidth(align: .toTheRightCentered, relativeTo: previewImage, padding: 50, height: 25, offset: -50)

        //Buttons
        favourite.align(.toTheRightCentered, relativeTo: previewImage, padding: 50, width: 50, height: 50, offset: 25)
        facebookButton.align(.toTheRightCentered, relativeTo: favourite, padding: 20, width: 50, height: 50, offset: 0)
        twitterButton.align(.toTheRightCentered, relativeTo: facebookButton, padding: 20, width: 50, height: 50, offset: 0)

        //Synopsis
        synopsisTitle.alignAndFillWidth(align: .underCentered, relativeTo: overlay, padding: 0, height: 25, offset: 0)
        synopsisTitle.frame = synopsisTitle.frame.offsetBy(dx: 50, dy: 125)
        synopsisContent.alignAndFillWidth(align: .underCentered, relativeTo: synopsisTitle, padding: 50, height: 25)
        synopsisContent.frame = synopsisContent.frame.offsetBy(dx: 0, dy: -25)
        synopsisContent.sizeToFit()

        //Review
        reviewTitle.alignAndFillWidth(align: .underCentered, relativeTo: synopsisContent, padding: 50, height: 25)
        reviewTitle.sizeToFit()
        reviewButton.align(.toTheRightCentered, relativeTo: reviewTitle, padding: 15, width: 30, height: 30)
        reviewCollection.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 0, height: 200)
        reviewCollection.frame = reviewCollection.frame.offsetBy(dx: 0, dy: 25)

        //Similar books
        similarTitle.alignAndFillWidth(align: .underCentered, relativeTo: reviewCollection, padding: 0, height: 25)
        similarTitle.frame = similarTitle.frame.offsetBy(dx: 50, dy: 25)
        similarCollection.alignAndFillWidth(align: .underCentered, relativeTo: similarTitle, padding: 0, height: 320)
        similarCollection.frame = similarCollection.frame.offsetBy(dx: 0, dy: 25)
        loadingSimilarCollection.align(.underCentered, relativeTo: similarTitle, padding: 0, width: 50, height: 50)
        loadingSimilarCollection.frame = loadingSimilarCollection.frame.offsetBy(dx: -50, dy: 100)

        //Recommendation
        googleRecommendationTitle.alignAndFillWidth(align: .underCentered, relativeTo: similarCollection, padding: 0, height: 25)
        googleRecommendationTitle.frame = googleRecommendationTitle.frame.offsetBy(dx: 50, dy: 25)
        googleRecommendationCollection.alignAndFillWidth(align: .underCentered, relativeTo: googleRecommendationTitle, padding: 0, height: 320)
        googleRecommendationCollection.frame = googleRecommendationCollection.frame.offsetBy(dx: 0, dy: 25)
        loadingGoogleRecommendation.align(.underCentered, relativeTo: googleRecommendationTitle, padding: 0, width: 50, height: 50)
        loadingGoogleRecommendation.frame = loadingGoogleRecommendation.frame.offsetBy(dx: 0, dy: 50)

        scrollView.fitToContent()
    }

    // MARK: - Setup Data
    fileprivate func setupData(for bookItem: (BookItem)) {
        
        self.previewTitle.text = bookItem.title
        self.previewSubtitle.text = (bookItem.author?.isEmpty ?? true) ? unknownAuthor : bookItem.author
        self.location.text = (bookItem.location?.isEmpty ?? true) ? unknownLocation : bookItem.location

        self.previewImageShadow.expand(into: self.scrollView, finished: nil)
        self.previewImage.expand(into: self.scrollView, finished: nil)
        
    }

    private func setupData() {
        
        var isBookLoaded = false
        // get the book by id
        if let book = CacheManager.shared.retrieveFromCache(itemID: bookId) {
            setupData(for: book)
            isBookLoaded = true
        }
        
        let book = api.getBook(byId: bookId)
            // add views and update labels after the book item is returned
            .do(onNext: { bookItem in
                self.view.addSubview(self.loading)
                self.loading.startAnimating()
                
                //If cache has not loaded book already
                if !isBookLoaded { self.setupData(for: bookItem) }
                
                self.addSubviews()
                self.setupGestures()
                
                self.setupFavouriteCounter()
                
                self.loading.stopAnimating()
                self.scrollView.animateFadeIn()
                    
                //Update the cached version of the book
                CacheManager.shared.addToCache(itemID: self.bookId, item: bookItem)},
                
                // showing the loading spinner notifying user it is going to load the similar media
                onCompleted: {
                    self.loadingSimilarCollection.startAnimating()
                    self.loadingGoogleRecommendation.startAnimating()
            })
            .share(replay: 1, scope: .forever)

        // send the api request to get books by same author
        book.flatMapLatest { self.getSimilarMedia(byAuthor: $0.author ?? self.unknownAuthor) }

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

        // send the api request to get books recommendation
        book.flatMapLatest { self.api.getBooksRecommendation(byTitle: $0.title ?? "") }
            // if the request produces any error, return empty array
            .catchErrorJustReturn([])

            // if no books are found, show no result message
            .do(onNext: { $0.isEmpty ? self.googleRecommendationCollection.displayEmptyResult() : () },
                // stop the spinner
                onCompleted: { self.loadingGoogleRecommendation.stopAnimating() })

            // bind result to collection view
            .bind(to: self.googleRecommendationCollection.rx.items(cellIdentifier: self.bookCollectionViewCellID, cellType: BookCollectionViewCell.self)) { index, model, cell in
                cell.data = model
                cell.title.text = model.title
                cell.subtitle.text = model.author
                cell.thumbnail.kf.setImage(with: model.thumbnail, options: [.transition(.fade(0.2))])
                cell.alpha = 0
                cell.animateFadeIn()
            }
            .disposed(by: disposeBag)

        // get reviews data from firebase
        book.subscribe(onNext: { (bookItem) in
            FirebaseDataSource().getReviewsForBook(bookId: self.bookId) { (reviews) in
                guard !reviews.isEmpty else {
                    self.reviewCollection.displayEmptyResult()
                    return
                }
                self.reviewCollection.backgroundView = nil
                self.reviewCollection.data = reviews
                self.reviewCollection.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }

    // MARK: - Lazy initialisation views
    private func addSubviews() {
        self.view.addSubview(self.scrollView)

        self.scrollView.addSubview(self.overlay)
        self.scrollView.addSubview(self.previewImageShadow)
        self.scrollView.addSubview(self.previewImage)
        self.scrollView.addSubview(self.previewTitle)
        self.scrollView.addSubview(self.previewSubtitle)
        self.scrollView.addSubview(self.location)
        self.scrollView.addSubview(self.favourite)
        self.scrollView.addSubview(self.synopsisTitle)
        self.scrollView.addSubview(self.synopsisContent)
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
        this.lineBreakMode = .byTruncatingTail
        this.numberOfLines = 3
        this.bounds.size = CGSize(width: 1, height: CGFloat(this.numberOfLines) * this.font.lineHeight)

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
        this.setImage(UIImage.fontAwesomeIcon(name: .heart, textColor: .white, size: CGSize(width: 40, height: 40)), for: .normal)
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
    
    func setupFavouriteCounter(){
        dbFavouriteCount.observe(.value, with: { (snapshot) in
            let favourite = snapshot.value as? [String: AnyObject] ?? [:]
            let favouriteCount = favourite["count"] as? Int ?? 0
            self.dbFavouriteCount.child("count").setValue(favouriteCount)
        })
    }
    
    // mark the heart with red if this item has been favourited before
    func checkHasFavourited(_ uid: String) {
        datasource.getFavourite(by: uid, bookid: bookId, completionHandler: { (isMarked) in
            if isMarked {
                self.favourite.setImage(UIImage.fontAwesomeIcon(name: .heart, textColor: .lipstickRed, size: CGSize(width: 40, height: 40)), for: .normal)
            }
            
        })
    }
    
    // setup valid tap action given valid uid
    func setupValidFavouriteTapAction(_ uid: String) {
        favourite.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { result in
                self.datasource.addToFavourite(by: uid, bookid: self.bookId, bookTitle: self.previewTitle.text ?? "Unknown Book" ) { isSuccess in
                    if isSuccess {
                        self.datasource.updateCount(bookid: self.bookId, value: -1)
                        self.favourite.setImage(UIImage.fontAwesomeIcon(name: .heart, textColor: .lipstickRed, size: CGSize(width: 40, height: 40)), for: .normal)
                    } else {
                        self.datasource.deleteFavourite(by: uid, bookid: self.bookId, completionHandler: {
                            self.datasource.updateCount(bookid: self.bookId, value: 1)
                            self.favourite.setImage(UIImage.fontAwesomeIcon(name: .heart, textColor: .white, size: CGSize(width: 40, height: 40)), for: .normal)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // setup invalid tap action if user has not logged in
    func setupInvalidFavouriteTapAction() {
        favourite.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { result in
                
                let alert = self.setupAlertController(title: "Favourite", message: "You must log in before adding to your favourite list.")
                
                self.present(alert, animated: false, completion: nil)
            }).disposed(by: disposeBag)
    }

    private(set) lazy var synopsisTitle: UILabel = {
        let this = UILabel()
        this.text = "SYNOPSIS"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()

    private(set) lazy var synopsisContent: UILabel = {
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
        
        return this
    }()
    
    func setupValidReviewTapAction(_ uid: String) {
        reviewButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.state?.postReview = self.state?.itemDetail
                self.performSegue(withIdentifier: "ItemDetailToPostReview", sender: self)
            })
            .disposed(by: disposeBag)
    }
    
    func setupInvalidReviewTapAction() {
        reviewButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { result in
                
                let alert = self.setupAlertController(title: "Review", message: "You must log in before writing reviews.")
                
                self.present(alert, animated: false, completion: nil)
            }).disposed(by: disposeBag)
    }

    private(set) lazy var reviewCollection: HorizontalCollectionView<ReviewCell> = {
        let this = HorizontalCollectionView<ReviewCell> {
            $0.cellSize = CGSize(width: 350, height: 200)
            $0.cellSpacing = 25
            $0.sectionPadding =  UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 0)
            $0.data = []
            $0.onDequeue = { cell, data, index in
                let items = data.map { $0 as! Review }

                cell.author.text = items[index].author
                cell.content.text = items[index].reviewText
                cell.rating.rating = Double(items[index].rating)
            }
        }

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
    
    func setupRecommendTapAction() {
        googleRecommendationCollection.rx.itemSelected.subscribe(onNext: { (index) in
            if let cell = self.googleRecommendationCollection.cellForItem(at: index) as? BookCollectionViewCell,
                let item = cell.data as? DisplayableItem,
                let link = item.infoLink {
                
                let alert = UIAlertController(title: "External Weblink", message: "This will open the link in your browser.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                    UIApplication.shared.open(link, options: [:], completionHandler: nil)
                })
                
                self.present(alert, animated: true)
                
            }
        }).disposed(by: disposeBag)
    }

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

    // MARK: - Helper methods
    private func getSimilarMedia(byAuthor keyword: String) -> Observable<[BookItem]> {
        return Observable<String>
            .just(keyword)
            .flatMapLatest { self.api.getBooks(byAuthor: $0) }
    }

    private func setupSimilarMediaTapAction() {
        similarCollection.rx.modelSelected(BookItem.self)
            .subscribe(onNext: { model in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "itemDetail") as! ItemDetailViewController
                self.state?.itemDetail = model
                vc.state = self.state
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

        let loginManager = LoginManager()

        if AccessToken.current != nil {
            //            loginManager.logOut()
            self.postToFaceBook()
        } else {
            loginManager.logIn(publishPermissions: [.publishActions], viewController: self, completion: { (loginResult) in
                switch loginResult {
                case .failed(let error): print(error)
                case .cancelled: print("User cancelled login")
                case .success(grantedPermissions: _, declinedPermissions:  _, token: _):

                    let alert = self.setupAlertController(title: "Facebook", message: "You can share now")

                    self.present(alert, animated: false, completion: nil)
                }
            })
        }
    }

    @objc func shareToTwitter() {
        print("Twitter pressed")
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            self.displayTweet()
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    self.displayTweet()
                } else {
                    let alert = self.setupAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.")
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }

    func displayTweet() {
        let composer = TWTRComposer()
            composer.setText("Check out \(bookTitle) at NUS Libraries!")
            composer.setURL(URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover1.jpg")!)
            composer.show(from: self) { result in
            if ( result == .done) {
                print("Successfully composed Tweet")
            } else {
                print("Must have cancelled...")
            }
        }
    }

    private func postToFaceBook() {
        let content = LinkShareContent(url: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover1.jpg")!, quote: "Title")
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .automatic
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

    private func setupAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(okAction)
        return alert
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetail" || segue.identifier == "ItemDetailToPostReview" {
            if let vc = segue.destination as? BaseViewController {
                vc.state = state
            }

            if let vc = segue.destination as? PostReviewController {
                vc.state = state
            }
        }

    }
}
