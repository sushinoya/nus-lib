//
//  FavouriteCollectionViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class FavouriteCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var searchController: UISearchController!
    var filtered:[BookItem] = []
    
    var collectionview: UICollectionView!
    var bookCollectionViewCellID = "bookCollectionViewCell"
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    var bookListForSection0: [BookItem] = []
    var bookListForSection1: [BookItem] = []
    
    var filteredBookListForSecion0: [BookItem] = []
    var filteredBookListForSecion1: [BookItem] = []
    
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupCollectionView()
        setupSearchBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionview.fillSuperview()
    }
    
    func setupNavigationBar() {
        let listButton = UIButton(type: .system)
        listButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        listButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        listButton.addTarget(self, action: #selector(switchToListView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listButton)
        navigationItem.title = Constants.NavigationBarTitle.FavouriteTitle
    }
    
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
    
    private func setupCollectionView() {
        //Layout for CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        layout.sectionHeadersPinToVisibleBounds = true
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCollectionViewCellID)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        
        //Gesture for dragging and reordering of cell
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionview.addGestureRecognizer(longPressGesture)
        view.addSubview(collectionview)
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
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
    
    func getBookItem(at indexPath: IndexPath) -> BookItem {
        
        if isFiltering {
            switch indexPath.section {
            case 1: return filteredBookListForSecion1[indexPath.item]
            default:
                return filteredBookListForSecion0[indexPath.item]
            }
        } else {
            switch indexPath.section {
            case 1: return bookListForSection1[indexPath.item]
            default:
                return bookListForSection0[indexPath.item]
            }
        }
    }

    @objc
    func switchToListView(sender: UIButton) {
        self.navigationController?.pushViewController(FavouriteTableViewController(), animated: true)
    }
    
    
    /*
        Gesture for moving and dragging cell
     */
    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
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
}
