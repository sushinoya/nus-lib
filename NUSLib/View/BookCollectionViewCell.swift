//
//  ItemDisplayCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var titleView: UIView!
    var imageView: UIImageView!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var isHighlighted: Bool {
        didSet {
            hilightedCover.isHidden = !isHighlighted
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        hilightedCover.frame = bounds
        
        titleLabel.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 30)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        titleView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 30)
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        applyGradation(imageView)
    }
    
    private func setupViews() {
        imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        hilightedCover = UIView()
        hilightedCover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        hilightedCover.isHidden = true
        addSubview(hilightedCover)
        
        titleView = UIView()
        titleLabel = UILabel()
        addSubview(titleView)
        addSubview(titleLabel)
    }
    
    private func applyGradation(_ gradientView: UIView!) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = gradientView.bounds
        
        let mainColor = UIColor(white: 0, alpha: 0.3).cgColor
        let subColor = UIColor.clear.cgColor
        gradientLayer!.colors = [subColor, mainColor]
        gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(gradientLayer!)
    }
}
