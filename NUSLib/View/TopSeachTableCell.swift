//
//  TopSearchTableCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class TopSeachTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.fillSuperview()
        
        thumbnail.anchorAndFillEdge(.left, xPad: 25, yPad: 25, otherSize: 125)
        thumbnailShadow.anchorAndFillEdge(.left, xPad: 25, yPad: 25, otherSize: thumbnail.height)
        
        topSearchLabel.align(.toTheRightMatchingTop, relativeTo: thumbnail, padding: 15, width: 170, height: 25)
        topSearchLabel.sizeToFit()
        
        author.align(.underMatchingLeft, relativeTo: topSearchLabel, padding: 0, width: 170, height: 25)
        author.sizeToFit()
        
        abstract.align(.underMatchingLeft, relativeTo: author, padding: 0, width: 170, height: 25)
        abstract.sizeToFit()
        
        separator.anchorInCenter(width: 0.5, height: contentView.height)
        separator.frame = separator.frame.insetBy(dx: 0, dy: 25)
        
        thumbnail2.align(.toTheRightCentered, relativeTo: separator, padding: 25, width: 125, height: 125)
        thumbnailShadow2.align(.toTheRightCentered, relativeTo: separator, padding: 25, width: 125, height: 125)
        
        topSearchLabel2.align(.toTheRightMatchingTop, relativeTo: thumbnail2, padding: 15, width: 170, height: 25)
        topSearchLabel2.sizeToFit()
        
        author2.align(.underMatchingLeft, relativeTo: topSearchLabel2, padding: 0, width: 170, height: 25)
        author2.sizeToFit()
        
        abstract2.align(.underMatchingLeft, relativeTo: author2, padding: 0, width: 170, height: 25)
        abstract2.sizeToFit()
    }
    
    private func setupViews() {
        contentView.addSubview(thumbnailShadow)
        contentView.addSubview(thumbnail)
        contentView.addSubview(topSearchLabel)
        contentView.addSubview(author)
        contentView.addSubview(abstract)
        
        contentView.addSubview(separator)
        
        contentView.addSubview(thumbnailShadow2)
        contentView.addSubview(thumbnail2)
        contentView.addSubview(topSearchLabel2)
        contentView.addSubview(author2)
        contentView.addSubview(abstract2)
    }
    
    private(set) lazy var thumbnail: UIImageView = {
        let this = UIImageView()
        this.kf.setImage(with: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg"),
                         options: [.transition(.fade(0.2))])
        this.contentMode = .scaleAspectFill
        this.layer.masksToBounds = true
        this.layer.cornerRadius = 20
        this.clipsToBounds = true
        
        return this
    }()
    
    private(set) lazy var thumbnailShadow: UIView = {
        let this = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 125, height: 125)))
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
    
    private(set) lazy var topSearchLabel: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .primary
        
        return this
    }()
    
    private(set) lazy var author: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .gray
        
        return this
    }()
    
    private(set) lazy var abstract: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .lightGray
        this.text = "Spare ribs fatback biltong brisket beef tri-tip salami leberkas ball tip hamburger shank beef ribs doner flank."
        
        return this
    }()
    
    private(set) lazy var separator: UIView = { [unowned self] in
        let this = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0.5, height: self.height)))
        this.backgroundColor = .gray
        return this
    }()
    
    private(set) lazy var thumbnail2: UIImageView = {
        let this = UIImageView()
        this.kf.setImage(with: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg"),
                         options: [.transition(.fade(0.2))])
        this.contentMode = .scaleAspectFill
        this.layer.masksToBounds = true
        this.layer.cornerRadius = 20
        this.clipsToBounds = true
        
        return this
    }()
    
    private(set) lazy var thumbnailShadow2: UIView = {
        let this = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 125, height: 125)))
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
    
    private(set) lazy var topSearchLabel2: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .primary
        
        return this
    }()
    
    private(set) lazy var author2: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .gray
        
        return this
    }()
    
    private(set) lazy var abstract2: UILabel = {
        let this = UILabel()
        this.textAlignment = .left
        this.font = UIFont.subsubtitle
        this.numberOfLines = 0
        this.lineBreakMode = .byWordWrapping
        this.textColor = .lightGray
        this.text = "Spare ribs fatback biltong brisket beef tri-tip salami leberkas ball."
        
        return this
    }()
}
