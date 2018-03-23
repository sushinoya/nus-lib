//
//  HorizontalCollectionView.swift
//  NUSLib
//
//  Created by wongkf on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class HorizontalCollectionView<T: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var cellCount: Int!
    private var cellSize: CGSize!
    private var sectionPadding: UIEdgeInsets!
    private var cellSpacing: CGFloat!
    
    init(frame: CGRect, cellCount: Int, cellSize: CGSize, cellSpacing: CGFloat = 0, sectionPadding: UIEdgeInsets = UIEdgeInsets.zero){
        super.init(frame: frame, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        self.sectionPadding = sectionPadding
        self.cellCount = cellCount
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
        
        self.delegate = self
        self.dataSource = self
        
        // automatically infer reusable identifier from the class name and register it
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // force single row only
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
