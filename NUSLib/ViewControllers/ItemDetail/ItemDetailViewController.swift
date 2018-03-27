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
    
    private(set) lazy var similarCollection: HorizontalCollectionView<ThumbnailCell> = {
        let this = HorizontalCollectionView<ThumbnailCell>(frame: CGRect.zero,
                                                           cellCount: 10,
                                                           cellSize: CGSize(width: 200, height: 150),
                                                           cellSpacing: 20,
                                                           sectionPadding: UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 20))
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        this.isPagingEnabled = true
        return this
    }()
    
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
        sypnosisTitle.alignAndFillWidth(align: .underCentered, relativeTo: overlay, padding: 0, height: 25, offset: 0)
        sypnosisTitle.frame = sypnosisTitle.frame.offsetBy(dx: 50, dy: 100)
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
    }
}



