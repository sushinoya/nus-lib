//
//  SimilarBooksCell.swift
//  NUSLib
//
//  Created by Liang on 22/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class SimilarBookCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseableCell = "CellId"
    var cellHeight: CGFloat = 0
    
    var data: [BookItem] = []
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseableCell)
        setupViews()
        collectionView.register(similarBookCollectionCell.self, forCellWithReuseIdentifier: reuseableCell)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.fillSuperview()        
    }
    
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableCell, for: indexPath) as! similarBookCollectionCell
        
        cell.titleLabel.text = data[indexPath.row].getTitle()
        cell.imageView.image = data[indexPath.row].getThumbNail()
        
        return cell
    }
}

class similarBookCollectionCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.fillSuperview()
        
        titleLabel.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 30)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
    }
    
    private func setupViews() {
        imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        titleLabel = UILabel()
        addSubview(titleLabel)
    }
}
