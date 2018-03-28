//
//  ItemDetailSimilarBookTableCell.swift
//  NUSLib
//
//  Created by Liang on 22/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class ItemDetailSimilarBookTableCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseableCell = "CellId"
    var cellHeight: CGFloat = 0
    
    var books: [BookItem] = []
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseableCell)
        setupViews()
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: reuseableCell)
        
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
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableCell, for: indexPath) as! BookCollectionViewCell
        
        cell.title.text = books[indexPath.row].getTitle()
        cell.thumbnail.image = books[indexPath.row].getThumbNail()
        
        return cell
    }
}

