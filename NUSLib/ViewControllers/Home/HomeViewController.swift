//
//  HomeViewController.swift
//  NUSLib
//
//  Created by wongkf on 14/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import ZFRippleButton
import RxSwift
import RxCocoa
import RxGesture
import SideMenu

class HomeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let popularTitle = UILabel()
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionview: UICollectionView!
    
    let recommendTitle = UILabel()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        popularTitle.anchorAndFillEdge(.top, xPad: 15, yPad: 35, otherSize: 100)
        collectionview.alignAndFillWidth(align: .underCentered, relativeTo: popularTitle, padding: 0, height: 100, offset: 0)
        recommendTitle.alignAndFillWidth(align: .underCentered, relativeTo: collectionview, padding: 15, height: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(popularTitle)
        popularTitle.textColor = UIColor.primary
        popularTitle.text = "POPULAR"
        popularTitle.textAlignment = .left
        popularTitle.font = UIFont.primary
        
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        layout.scrollDirection = .horizontal
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.addSubview(collectionview)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(PopularCell.self, forCellWithReuseIdentifier: "PopularCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        collectionview.isPagingEnabled = true
        
        view.addSubview(recommendTitle)
        recommendTitle.textColor = UIColor.primary
        recommendTitle.text = "RECOMMEND"
        recommendTitle.textAlignment = .left
        recommendTitle.font = UIFont.primary
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCell
        cell.addViews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

}


class PopularCell: UICollectionViewCell {

    func addViews(){
        backgroundColor = UIColor.accent1
        layer.cornerRadius = 10
    }
}
