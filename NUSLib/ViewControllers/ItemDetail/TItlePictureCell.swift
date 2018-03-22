//
//  TItlePictureCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class TitlePictureCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var thumbImageView: UIImageView!
    var ratingLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbImageView.anchorToEdge(.left, padding: 0, width: self.frame.width * 0.3, height: self.frame.height)
        
        titleLabel.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: thumbImageView, padding: 8, height: 30)

        ratingLabel.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: thumbImageView, padding: 8, height: 30, offset: titleLabel.frame.height)
        
        
        ratingLabel.textColor = UIColor.black
        titleLabel.textColor = UIColor.black
        
    }
    
    private func setupViews() {
        thumbImageView = UIImageView()
        thumbImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        addSubview(thumbImageView)
        
        titleLabel = UILabel()
        addSubview(titleLabel)
        
        ratingLabel = UILabel()
        addSubview(ratingLabel)
    }
    
}
