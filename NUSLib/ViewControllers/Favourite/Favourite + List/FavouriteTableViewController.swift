//
//  FavouriteTableViewController.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RxSwift
import RxCocoa

class FavouriteTableViewController: BaseViewController {
    
    //MARK: - Variables
    var isFiltering: Bool = false
    var isEditingMode = false
    let bookTableViewCellID = "bookTableViewCell"
    
    var bookLists: [[DisplayableItem]] = []
    var filteredLists: [[DisplayableItem]] = []
    
    let ds: AppDataSource = FirebaseDataSource()
    let library: LibraryAPI = CentralLibrary()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        addSubViews()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = Constants.NavigationBarTitle.FavouriteTitle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.fillSuperview()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    //MARK: - Setup Data
    func setupData() {
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
                    self.tableView.reloadData()
                })
                
            })
        }
    }
    
    //MARK: - Lazy initionlization views
    private func addSubViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
        //Search Bar only appear when user pull the view down
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.height) , animated: true)
    }
    
    lazy var searchController: UISearchController = { [unowned self] in
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.sizeToFit()
        return searchController
        }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: bookTableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        }()
    
    //MARK: - Helper methods
    func getBookItem(at indexPath: IndexPath) -> DisplayableItem {
        if isFiltering {
            return filteredLists[indexPath.section][indexPath.item]
        } else {
            return bookLists[indexPath.section][indexPath.item]
        }
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
    
    //Mark: - TableView Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
