//
//  TopSearchTableCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class TopSeachTableCell: UITableViewCell {
    
    var topSearchLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topSearchLabel.frame = bounds
        topSearchLabel.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: self.width)
    }
    
    private func setupViews() {
        topSearchLabel = UILabel()
        topSearchLabel.textAlignment = .center
        contentView.addSubview(topSearchLabel)
    }
    
}
