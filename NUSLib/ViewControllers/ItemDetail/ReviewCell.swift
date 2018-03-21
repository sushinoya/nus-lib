//
//  ReviewCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class ReviewCell: UITableViewCell {
    
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
        
        // Use RGB colour
        reviewTextView.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        
        // Update UITextView font size and colour
        reviewTextView.font = UIFont.systemFont(ofSize: 20)
        reviewTextView.textColor = UIColor.white
        
        reviewTextView.font = UIFont.boldSystemFont(ofSize: 20)
        reviewTextView.font = UIFont(name: "Verdana", size: 17)
        
        // Capitalize all characters user types
        reviewTextView.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        // Make UITextView web links clickable
        reviewTextView.isSelectable = true
        reviewTextView.isEditable = false
        reviewTextView.dataDetectorTypes = UIDataDetectorTypes.link
        
        // Make UITextView corners rounded
        reviewTextView.layer.cornerRadius = 10
        
        // Enable auto-correction and Spellcheck
        reviewTextView.autocorrectionType = UITextAutocorrectionType.yes
        reviewTextView.spellCheckingType = UITextSpellCheckingType.yes
        // myTextView.autocapitalizationType = UITextAutocapitalizationType.None
        
        // Make UITextView Editable
        reviewTextView.isEditable = true
        
        addSubview(reviewTextView)
    }
    
}
