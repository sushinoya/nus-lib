//
//  FavouriteCollectionViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class FavouriteCollectionViewController: BaseViewController {
    
    //MARK: - Variables
    var bookCollectionViewCellID = "bookCollectionViewCell"
    var isFiltering = false
    var isEditingMode = false
    
    var deleteButton: UIButton!
    var longPressGesture: UILongPressGestureRecognizer!
    
    var bookLists: [[DisplayableItem]] = []
    var filteredLists: [[DisplayableItem]] = []
    
    let ds: AppDataSource = FirebaseDataSource()
    let library: LibraryAPI = CentralLibrary()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubViews()
        setUpGesture()
        self.definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.setupData()
    }
    
    private func setupNavigationBar() {
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //CollectionView
        collectionview.anchorToEdge(.top, padding: 20, width: view.frame.width, height: view.frame.height)
    }
    
    //MARK: - Setup Data
    private func setupData() {
        let books = [BookItem]()
        
        bookLists.removeAll()
        filteredLists.removeAll()
        
        //2 sections for bookLists
        bookLists.append(books)
        bookLists.append(books)
        filteredLists.append(books)
        filteredLists.append(books)
        
        if let user = ds.getCurrentUser() {
            ds.getFavouriteBookListForUser(userID: user.getUserID(), completionHandler: { (ids) in
                self.library.getBooks(byIds: ids, completionHandler: { (items) in
                    self.bookLists[0] = items
                    self.collectionview.reloadData()
                    self.filter(searchTerm: self.searchBar.text!)
                })
            })
        }
    }
    
    //MARK: - Lazy initionlization views
    private func addSubViews() {
        view.addSubview(collectionview)
        view.addSubview(searchBar)
    }
    
    lazy var collectionview: UICollectionView = { [unowned self] in
        //Layout for CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = false
        let collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionview.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: bookCollectionViewCellID)
        collectionview.backgroundColor = UIColor.white
        collectionview.dataSource = self
        collectionview.delegate = self
        return collectionview
        }()
    
    lazy var searchBar: UISearchBar = {[unowned self] in
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        searchBar.placeholder = "Search Title"
        searchBar.tintColor = .blue
        searchBar.delegate = self
        return searchBar
        }()
    
    //MARK: - Helper methods
    private func setUpGesture() {
        //Gesture for dragging and reordering of cell
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionview.addGestureRecognizer(longPressGesture)
    }
    
    func filter(searchTerm: String) {
        if searchTerm.isEmpty {
            isFiltering = false
            filteredLists.removeAll()
        } else {
            isFiltering = true
            for section in 0..<bookLists.count {
                filteredLists.append([BookItem]())
                filteredLists[section] = bookLists[section].filter({return $0.title!.localizedCaseInsensitiveContains(searchTerm)})
            }
        }
    }
    
    func getBookItem(at indexPath: IndexPath) -> DisplayableItem {
        
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
        if let indexpaths = collectionview.indexPathsForSelectedItems {
            for indexPath in indexpaths.sorted().reversed() {
                var item: DisplayableItem?
                if isFiltering {
                    item = filteredLists[indexPath.section].remove(at: indexPath.item)
                } else {
                    item = bookLists[indexPath.section].remove(at: indexPath.item)
                }
                
                if let user = ds.getCurrentUser() {
                    ds.deleteFavourite(by: user.getUserID(), bookid: (item?.id)!, completionHandler: {
                        self.ds.updateCount(bookid: (item?.id)!, value: 1)
                    })
                }
               
            }
            self.collectionview.deleteItems(at: indexpaths)
        }
    }
}
