//
//  ItemDisplayCell.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    var data: Any?

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

    private(set) lazy var overlay: UIView = {
        let this = UIView()
        this.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return this
    }()

    private(set) lazy var title: UILabel = {
        let this = UILabel()
        this.text = "Bacon ipsum dolor amet flank shankle"
        this.textColor = UIColor.primary
        this.textAlignment = .left
        this.font = UIFont.title
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

    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 3.0
            self.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
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
        // layout must come after adding ui to the scene
        thumbnail.frame = bounds
//        thumbnail.fillSuperview()
        overlay.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 75)
        subtitle.anchorAndFillEdge(.bottom, xPad: 10, yPad: 10, otherSize: 25)
        title.alignAndFillWidth(align: .aboveCentered, relativeTo: subtitle, padding: 0, height: 25)
        title.frame = title.frame.offsetBy(dx: 10, dy: 0)

        overlay.roundCorners([.bottomLeft, .bottomRight], radius: 20)

        backgroundColor = UIColor.clear
        clipsToBounds = false

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }

    private func setupViews() {
        addSubview(thumbnail)
        addSubview(overlay)
        addSubview(subtitle)
        addSubview(title)

    }

}
