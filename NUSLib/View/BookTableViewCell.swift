//
//  BookShelfCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class BookTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var thumbImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.3, height: self.frame.height - 10)
        
        self.textLabel?.alignAndFill(align: .toTheRightCentered, relativeTo: self.imageView!, padding: 8)
        
    
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
        
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
    }
    
    private func setupViews() {
        thumbImageView = UIImageView()
        thumbImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        addSubview(thumbImageView)
        
        titleLabel = UILabel()
        addSubview(titleLabel)
    }
}
