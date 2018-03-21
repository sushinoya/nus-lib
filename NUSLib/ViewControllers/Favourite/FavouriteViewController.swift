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

class FavouriteViewController: UIViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UISearchBarDelegate {
    
    //Search Bar
    var searchController: UISearchController!
    var filtered:[BookItem] = []
    var searchBarActive : Bool = false
    
    
    //Collection View
    var collectionview: UICollectionView!
    var cellId = "itemCell"
    
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
        let layout: RAReorderableLayout = RAReorderableLayout()
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
    }
    
    // MARK: - Setup SearchBar
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.delegate = self
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
