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
    
    var searchController: UISearchController!
    
    var tableView: UITableView!
    let bookTableViewCellID = "bookTableViewCell"

    var bookListForSection0: [BookItem] = []
    var bookListForSection1: [BookItem] = []
    
    var filteredBookListForSecion0: [BookItem] = []
    var filteredBookListForSecion1: [BookItem] = []
    
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = Constants.NavigationBarTitle.FavouriteTitle
    }
    
    private func setupData() {
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
    
    private func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: bookTableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
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
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
}
