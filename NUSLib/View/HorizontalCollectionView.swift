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
    
    var data: [Any] = []
    
    private var onDequeue: ((T, [Any], IndexPath) -> ())?
    
    init(frame: CGRect, cellCount: Int, cellSize: CGSize, cellSpacing: CGFloat = 0, sectionPadding: UIEdgeInsets = UIEdgeInsets.zero, data: [Any], onDequeue: ((T, [Any], IndexPath) -> ())?){
        super.init(frame: frame, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        self.onDequeue = onDequeue
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
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        
        if let configure = onDequeue {
            configure(cell, data, indexPath)
        }
        
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
    
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView is UICollectionView {
                return nil
            } else {
                print(hitView)
               return hitView
            }
        } else {
            return nil
        }
    }*/
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("OMG")
        /*let cell = cellForItem(at: indexPath)
        (cell as! ThumbnailCell).thumbnail.rx
            .tapGesture()
            .when(.recognized)
            .subscribe ({ _ in
                print(indexPath)
            })
            .disposed(by: disposeBag)*/
    }*/
}
