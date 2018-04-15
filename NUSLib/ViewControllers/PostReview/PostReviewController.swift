//
//  PostReviewController.swift
//  NUSLib
//
//  Created by wongkf on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import Cosmos
import ZFRippleButton
import RxSwift
import RxCocoa
import RxGesture

class PostReviewController: UIViewController {
    
    //MARK: - Variables
    let disposeBag = DisposeBag()
    let datasource: AppDataSource = FirebaseDataSource()
    var state: StateController?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        
    }
    
    override func viewWillLayoutSubviews() {
        reviewTitle.anchorAndFillEdge(.top, xPad: 25, yPad: 25, otherSize: 25)
        reviewTitle.sizeToFit()
        reviewTextArea.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 25, height: 230)
        reviewSeparator.alignAndFillWidth(align: .underCentered, relativeTo: reviewTextArea, padding: 0, height: 0.5)
        reviewSeparator.bounds = reviewSeparator.frame.insetBy(dx: 20, dy: 0)
        ratingView.align(.underCentered, relativeTo: reviewTextArea, padding: 25, width: ratingView.width ,height: 50)
        cancel.align(.underMatchingLeft, relativeTo: reviewTextArea, padding: 25, width: 200, height: 40)
        cancel.frame = cancel.frame.offsetBy(dx: 25, dy: ratingView.height + 10)
        submit.align(.underMatchingRight, relativeTo: reviewTextArea, padding: 25, width: 200, height: 40)
        submit.frame = submit.frame.offsetBy(dx: -25, dy: ratingView.height + 10)
        
    }
    
    //MARK: - Lazy initialisation views
    private func addSubViews() {
        view.addSubview(reviewTitle)
        view.addSubview(reviewTextArea)
        view.addSubview(reviewSeparator)
        view.addSubview(ratingView)
        view.addSubview(submit)
        view.addSubview(cancel)
    }
    
    private(set) lazy var reviewTitle: UILabel = {
        let this = UILabel()
        this.text = "MY REVIEW"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.secondary
        this.lineBreakMode = .byWordWrapping
        this.numberOfLines = 0
        return this
    }()
    
    private(set) lazy var reviewTextArea: UITextView = {
        let this = UITextView()
        this.font = .reviewPost
        this.becomeFirstResponder()
        return this
    }()
    
    lazy var reviewSeparator: Separator = { [unowned self] in
        let this = Separator(width: view.bounds.width)
        return this
    }()
    
    private(set) lazy var ratingView: CosmosView = {
        let this = CosmosView()
        this.rating = 5
        this.settings.starSize = 40
        this.settings.starMargin = 5
        this.settings.filledImage = #imageLiteral(resourceName: "GoldStar")
        this.settings.emptyImage = #imageLiteral(resourceName: "GoldStarEmpty")
        
        return this
    }()
    
    private(set) lazy var submit: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setTitle("SUBMIT", for: .normal)
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
                self.submitReview()
            })
            .disposed(by: disposeBag)
        
        return this
    }()
    
    private(set) lazy var cancel: ZFRippleButton = { [unowned self] in
        let this = ZFRippleButton()
        this.setTitle("CANCEL", for: .normal)
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
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return this
        }()
    
    //MARK: - Helper methods
    func submitReview(){
        guard let user = datasource.getCurrentUser() else {
            return
        }
        
        guard let bookTitle = self.state?.itemDetail?.title else {
            return
        }
        
        datasource.addReview(by: user.getUserID(), userName: user.getUsername(), for: state?.postReview?.id ?? "", title: bookTitle, review: reviewTextArea.text, rating: Int(ratingView.rating))
        
        self.dismiss(animated: true)
    }
}
