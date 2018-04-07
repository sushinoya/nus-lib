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

class PostReviewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        reviewTitle.anchorAndFillEdge(.top, xPad: 25, yPad: 25, otherSize: 25)
        reviewTitle.sizeToFit()
        reviewTextArea.alignAndFillWidth(align: .underCentered, relativeTo: reviewTitle, padding: 25, height: 300)
        reviewSeparator.alignAndFillWidth(align: .underCentered, relativeTo: reviewTextArea, padding: 0, height: 0.5)
        reviewSeparator.bounds = reviewSeparator.frame.insetBy(dx: 20, dy: 0)
        rating.alignAndFillWidth(align: .underCentered, relativeTo: reviewTextArea, padding: 25, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(reviewTitle)
        view.addSubview(reviewTextArea)
        view.addSubview(reviewSeparator)
        view.addSubview(rating)
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
    
    private(set) lazy var rating: CosmosView = {
        let this = CosmosView()
        this.rating = Double(arc4random_uniform(6))
        this.settings.starSize = 40
        this.settings.starMargin = 5
        return this
    }()
}
