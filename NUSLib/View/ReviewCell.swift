//
//  ReviewCell.swift
//  NUSLib
//
//  Created by wongkf on 5/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UICollectionViewCell {
    private(set) lazy var avatar: UIImageView = {
        let this = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)))
        this.kf.setImage(with: URL(string: "https://randomuser.me/api/portraits/men/\(Int(arc4random_uniform(30)+1)).jpg"), options: [.transition(.fade(0.2))])
        this.contentMode = .scaleAspectFill
        this.layer.masksToBounds = true
        this.layer.cornerRadius = 25
        this.clipsToBounds = true
        return this
    }()
    
    private(set) lazy var author: UILabel = {
        let this = UILabel()
        this.text = "Bacon Ipsum"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.title
        this.backgroundColor = UIColor.clear
        this.numberOfLines = 1
        return this
    }()
    
    private(set) lazy var authorInfo: UILabel = {
        let this = UILabel()
        this.text = "Year 3, Computer Science."
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        this.backgroundColor = UIColor.clear
        this.numberOfLines = 1
        return this
    }()
    
    private(set) lazy var content: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet ribeye ham hock bacon, short ribs capicola t-bone meatloaf ham fatback ball tip cow drumstick cupim. Chuck capicola ground round biltong. Cow tail biltong tenderloin buffalo beef pork chop corned beef turkey ground round bacon shoulder chuck tri-tip ball tip. "
        this.textColor = UIColor.primary
        this.textAlignment = .justified
        this.font = UIFont.reviewContent
        this.lineBreakMode = .byTruncatingTail
        this.numberOfLines = 0
        
        return this
    }()
    
    private(set) lazy var rating: CosmosView = {
        let this = CosmosView()
        this.rating = Double(arc4random_uniform(6))
        this.settings.starSize = 15
        this.settings.starMargin = 5
        this.settings.updateOnTouch = false
        return this
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatar)
        addSubview(author)
        addSubview(authorInfo)
        addSubview(content)
        addSubview(rating)
        
        avatar.anchorInCorner(.topLeft, xPad: 25, yPad: 25, width: 50, height: 50)
        author.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: avatar, padding: 15, height: 25)
        authorInfo.alignAndFillWidth(align: .toTheRightMatchingBottom, relativeTo: avatar, padding: 15, height: 25)
        
        content.alignAndFillWidth(align: .underCentered, relativeTo: author, padding: 25, height: 80)
        
        rating.alignAndFillWidth(align: .underCentered, relativeTo: content, padding: 0, height: 25)
        rating.frame = rating.frame.offsetBy(dx: 25, dy: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
