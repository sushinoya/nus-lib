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

class ItemDetailViewController: BaseViewController {
    
    private(set) lazy var previewImage: UIView = {
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
        return this
    }()
    
    private(set) lazy var previewSubtitle: UILabel = {
        let this = UILabel()
        this.text = "Drumstick short ribs turducken"
        this.textColor = UIColor.gray
        this.textAlignment = .left
        this.font = UIFont.title
        return this
    }()
    
    private(set) lazy var author: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet flank shankle,  Ribeye shankle short loin."
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.subtitle
        return this
    }()
    
    private(set) lazy var location: UILabel = {
        let this = UILabel()
        this.text = "Drumstick short ribs turducken"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.subtitle
        return this
    }()
    
    private(set) lazy var favourite: ZFRippleButton = {
        let this = ZFRippleButton()
        this.setTitle("FAVOURITE", for: .normal)
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
    
    private(set) lazy var overlay: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor.primary
        return this
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        overlay.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: view.bounds.height*1/3)
        previewImage.anchorInCorner(.topLeft, xPad: 100, yPad: 100, width: 300, height: 500)
        previewTitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: 25)
        previewTitle.sizeToFit()
        previewSubtitle.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: previewImage, padding: 50, height: 25, offset: previewTitle.height)
        previewSubtitle.sizeToFit()
        favourite.align(.toTheRightCentered, relativeTo: previewImage, padding: 50, width: 250, height: 50)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(overlay)
        view.addSubview(previewImage)
        view.addSubview(previewTitle)
        view.addSubview(previewSubtitle)
        view.addSubview(favourite)
    }
}



