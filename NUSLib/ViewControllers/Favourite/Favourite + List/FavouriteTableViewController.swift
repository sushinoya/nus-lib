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
    
    let bookTableViewCellID = "bookTableViewCell"

    var bookLists: [[BookItem]] = []
    var filteredLists: [[BookItem]] = []
    
    var isFiltering: Bool = false
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupView()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = Constants.NavigationBarTitle.FavouriteTitle
    }
    
    func setupData() {
        let books = [BookItem]()
        
        bookLists.append(books)
        bookLists.append(books)
        filteredLists.append(books)
        filteredLists.append(books)
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
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
        //Search Bar only appear when user pull the view down
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.height) , animated: true)
    }
    
    func getBookItem(at indexPath: IndexPath) -> BookItem {
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
                filteredLists[section] = bookLists[section].filter({return $0.getTitle().localizedCaseInsensitiveContains(searchTerm)})
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                filteredLists[indexPath.section].remove(at: indexPath.item)
            } else {
                bookLists[indexPath.section].remove(at: indexPath.item)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemDetailVC = segue.destination as? ItemDetailViewController {
            // MARK: - TODO: Pass an item to ItemDetailViewController
            itemDetailVC.selectedString = "selectedString"
        }
    }
}
