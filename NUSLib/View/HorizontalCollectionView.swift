//
//  HorizontalCollectionView.swift
//  NUSLib
//
//  Created by wongkf on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HorizontalCollectionView<T: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let disposeBag = DisposeBag()
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var cellCount: Int!
    private var cellSize: CGSize!
    private var sectionPadding: UIEdgeInsets!
    private var cellSpacing: CGFloat!
    
    private var data: [Any] = []
    
    private var onDequeue: ((T, [Any], IndexPath) -> ())?
    
    init(frame: CGRect, cellCount: Int, cellSize: CGSize, cellSpacing: CGFloat = 0, sectionPadding: UIEdgeInsets = UIEdgeInsets.zero, data: [Any]?, onDequeue: ((T, [Any], IndexPath) -> ())?){
        super.init(frame: frame, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        self.sectionPadding = sectionPadding
        self.cellCount = cellCount
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
        self.onDequeue = onDequeue
        
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
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        
        onDequeue?(cell, data, indexPath)
        
        return cell
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
    
    func getCell(indexPath: IndexPath) -> T {
        
        return cellForItem(at: indexPath) as! T
    }
}
