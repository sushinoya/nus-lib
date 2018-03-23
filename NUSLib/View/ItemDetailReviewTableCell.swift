//
//  ItemDetailReviewTableCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class ItemDetailReviewTableCell: UITableViewCell {
    
    var reviewTextView: UITextView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reviewTextView.frame = bounds
    }
    
    private func setupViews() {
        reviewTextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        
        reviewTextView.center = self.center
        reviewTextView.textAlignment = .justified
        reviewTextView.backgroundColor = UIColor.lightGray
        
        // Update UITextView font size and colour
        reviewTextView.font = UIFont.systemFont(ofSize: 20)
        reviewTextView.textColor = UIColor.white
        
        // Make UITextView web links clickable
        reviewTextView.isSelectable = true
        reviewTextView.isEditable = false
        reviewTextView.dataDetectorTypes = UIDataDetectorTypes.link
        
        addSubview(reviewTextView)
    }
    
}
