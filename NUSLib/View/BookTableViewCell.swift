//
//  BookShelfCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import Kingfisher

class BookTableViewCell: UITableViewCell {
    
    override private (set) lazy var imageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg"),
                               options: [.transition(.fade(0.2))])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    
        return imageView
    }()
    
    override private (set) lazy var textLabel: UILabel? = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor.primary
        textLabel.textAlignment = .left
        textLabel.font = UIFont.title
        textLabel.text = "Bacon ipsum dolor amet flank shankle"
        return textLabel
    }()
    
    private(set) lazy var overlay: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return this
    }()
    
    private(set) lazy var subtitle: UILabel = {
        let this = UILabel()
        this.text = "Drumstick Andouille"
        this.textColor = UIColor.gray
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        return this
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView?.frame = CGRect(x: 10, y: 10, width: self.frame.width * 0.3, height: self.frame.height - 20)
        overlay.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 75)
        
        self.textLabel?.alignAndFill(align: .toTheRightCentered, relativeTo: self.imageView!, padding: 8)
        subtitle.alignAndFill(align: .toTheRightCentered, relativeTo: self.imageView!, padding: 8, offset: 36)
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
        overlay.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        
        backgroundColor = UIColor.clear
        clipsToBounds = false
        
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        
    }
    
    private func setupViews() {
        addSubview(textLabel!)
        addSubview(imageView!)
        addSubview(subtitle)
    }

}
