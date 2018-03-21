//
//  Favourite.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RAReorderableLayout

class FavouriteViewController: UIViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {
    
    //Search Bar
    var searchBar: UISearchBar!
    
    //Collection View
    var collectionview: UICollectionView!
    var cellId = "itemCell"
    
    var bookListForSection0: [BookItem] = []
    var bookListForSection1: [BookItem] = []
    
    var imagesForSection0: [UIImage] = []
    var imagesForSection1: [UIImage] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.anchorToEdge(.top, padding: 20, width: view.frame.width, height: 60)
        collectionview.alignAndFill(align: .underCentered, relativeTo: searchBar, padding: 0, offset: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        view.addSubview(searchBar)
        
        setupData()
        setupCollectionView()
        
    }
    
    
    //MARK: - Fake Data
    func setupData() {
        
        for index in 0..<18 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(title: name, image: image!)
            bookListForSection0.append(item)
        }
        for index in 18..<30 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(title: name, image: image!)
            bookListForSection1.append(item)
        }
    }
    
    //MARK: - Setup Collectionview
    func setupCollectionView() {
        let layout: RAReorderableLayout = RAReorderableLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(ItemDisplayCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        view.addSubview(collectionview)
    }


