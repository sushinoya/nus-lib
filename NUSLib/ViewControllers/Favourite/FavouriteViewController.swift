//
//  Favourite.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class FavouriteViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    //Search Bar
    var searchController: UISearchController!
    var filtered:[BookItem] = []
    
    //Collection View
    var collectionview: UICollectionView!
    var cellId = "itemCell"
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    var bookListForSection0: [BookItem] = []
    var bookListForSection1: [BookItem] = []
    
    var filteredBookListForSecion0: [BookItem] = []
    var filteredBookListForSecion1: [BookItem] = []
    
    var isFiltering: Bool = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview.fillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favourite"        
        setupData()
        setupCollectionView()
        setupSearchBar()
        
    }
    
    
    //MARK: - Fake Data
    func setupData() {
        
        for index in 0..<18 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(name: name, image: image!)
            bookListForSection0.append(item)
        }
        for index in 18..<30 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(name: name, image: image!)
            bookListForSection1.append(item)
        }
    }
    
    //MARK: - Setup Collectionview
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        layout.sectionHeadersPinToVisibleBounds = true
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(ItemDisplayCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        view.addSubview(collectionview)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionview.addGestureRecognizer(longPressGesture)
    
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionview.indexPathForItem(at: gesture.location(in: collectionview)) else {
                break
            }
            collectionview.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }
    
    // MARK: - Setup SearchBar
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Title"
        searchController.searchBar.tintColor = .blue
        searchController.searchBar.sizeToFit()
    
        collectionview.addSubview(searchController.searchBar)
        
    }
    
    
    func filter(searchTerm: String) {
        if searchTerm.isEmpty {
            isFiltering = false
            filteredBookListForSecion0.removeAll()
            filteredBookListForSecion1.removeAll()
        } else {
            isFiltering = true
            
            filteredBookListForSecion0 = bookListForSection0.filter({
                return $0.getTitle().localizedCaseInsensitiveContains(searchTerm)
            })
            
            filteredBookListForSecion1 = bookListForSection1.filter({
                return $0.getTitle().localizedCaseInsensitiveContains(searchTerm)
            })
        }
    }

    func objectForSection0(at indexPath: IndexPath) -> BookItem {
        if isFiltering {
            return filteredBookListForSecion0[indexPath.item]
        } else {
            return bookListForSection0[indexPath.item]
        }
    }
    
    func objectForSection1(at indexPath: IndexPath) -> BookItem {
        if isFiltering {
            return filteredBookListForSecion1[indexPath.item]
        } else {
            return bookListForSection1[indexPath.item]
        }
    }
    
}
