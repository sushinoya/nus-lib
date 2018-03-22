//
//  BookShelfCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class BookShelfTableCell: UITableViewCell {
    
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
        thumbImageView.anchorToEdge(.left, padding: 0, width: self.frame.width * 0.3, height: self.frame.height)
        
        titleLabel.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: thumbImageView, padding: 8, height: 30)
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
