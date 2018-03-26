//
//  FavouriteCollectionViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class FavouriteCollectionViewController: BaseViewController {
    /*
    var searchController: UISearchController!
    var filtered:[BookItem] = []
    
    var collectionview: UICollectionView!
    var bookCollectionViewCellID = "bookCollectionViewCell"
    
    var deleteButton: UIButton!
    var longPressGesture: UILongPressGestureRecognizer!
    
    var bookLists: [[BookItem]] = [[]]
    var filteredLists: [[BookItem]] = [[]]
    
    var isFiltering: Bool = false
    var isEditingMode = false
    
    var selectedItem: BookItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupCollectionView()
        setupSearchBar()
        self.definesPresentationContext = true;
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
        
        deleteButton = UIButton(type: .system)
        deleteButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        deleteButton.isHidden = !isEditing
        deleteButton.addTarget(self, action: #selector(deleteCells), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: listButton), editButtonItem, UIBarButtonItem(customView: deleteButton)]
        
        navigationItem.title = Constants.NavigationBarTitle.FavouriteTitle
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupData() {
        let books = [BookItem]()
        
        bookLists.append(books)
        bookLists.append(books)
        for index in 0..<18 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(name: name, image: image!)
            bookLists[0].append(item)
        }
        for index in 18..<30 {
            let name = "Sample\(index).jpg"
            let image = UIImage(named: name)
            let item = BookItem(name: name, image: image!)
            bookLists[1].append(item)
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
        //Search Bar only appear when user pull the view down
        collectionview.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.height) , animated: true)
        
    }
    
    
    func filter(searchTerm: String) {
        if searchTerm.isEmpty {
            isFiltering = false
            filteredLists.removeAll()
        } else {
            isFiltering = true
            for section in 0..<filteredLists.count {
                filteredLists[section] = bookLists[section].filter({return $0.getTitle().localizedCaseInsensitiveContains(searchTerm)})
            }
        }
    }
    
    func getBookItem(at indexPath: IndexPath) -> BookItem {
        
        if isFiltering {
            return filteredLists[indexPath.section][indexPath.item]
        } else {
           return bookLists[indexPath.section][indexPath.item]
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        isEditingMode = editing
        collectionview.allowsMultipleSelection = editing
        deleteButton.isHidden = !editing
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemDetailVC = segue.destination as? ItemDetailViewController {
            // MARK: - TODO: Pass an item to ItemDetailViewController
            itemDetailVC.selectedString = "selectedString"
            itemDetailVC.itemToDisplay = selectedItem
        }
    }
    
    @objc
    func switchToListView(sender: UIButton) {
        self.performSegue(withIdentifier: "CollectionToList", sender: self)
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
    
    @objc
    func deleteCells() {
        if let indexpaths = collectionview?.indexPathsForSelectedItems {
            for indexPath in indexpaths.sorted().reversed() {
                if isFiltering {
                    
                    filteredLists[indexPath.section].remove(at: indexPath.item)
                   
                } else {
                    bookLists[indexPath.section].remove(at: indexPath.item)
                }
            }
            collectionview.deleteItems(at: indexpaths)
        }
    }*/
}
