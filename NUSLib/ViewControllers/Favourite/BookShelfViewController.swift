//
//  BookShelfViewController.swift
//  NUSLib
//
//  Created by Liang on 21/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RxSwift
import RxCocoa

class BookShelfViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchController: UISearchController!
    
    var tableView: UITableView!
    let tableViewCellID = "bookShelfCellID"
    

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func setupNavigationBar() {
        let listButton = UIButton(type: .system)
        listButton.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        listButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        listButton.addTarget(self, action: #selector(switchToGridView), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listButton)
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
    
    //MARK: - Setup TableView
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(BookShelfTableCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    //MARK: - Setup Search Bar
    func setupSearchBar() {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if section == 0 {
                return filteredBookListForSecion0.count
            }else {
                return filteredBookListForSecion1.count
            }
        } else {
            if section == 0 {
                return bookListForSection0.count
            }else {
                return bookListForSection1.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! BookShelfTableCell
        
        if indexPath.section == 0 {
            let book = objectForSection0(at: indexPath)
            cell.thumbImageView.image = book.getThumbNail()
            cell.titleLabel.text = book.getTitle()
        } else {
            let book = objectForSection1(at: indexPath)
            cell.thumbImageView.image = book.getThumbNail()
            cell.titleLabel.text = book.getTitle()
            
        }
        return cell
    }
    
    // MARK: UISearchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchTerm: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        filter(searchTerm: "")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    @objc func switchToGridView(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
