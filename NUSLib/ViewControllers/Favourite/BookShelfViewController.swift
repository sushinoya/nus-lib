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

class BookShelfViewController: UIViewController {
    
    var searchController: UISearchController!
    
    var tableView: UITableView!
    let tableViewCellID = "bookShelfCellID"
    
    var searchValue: Variable<String> = Variable("")
    var bookList: Variable<[String]> = Variable([])
    var filterResult: Variable<[String]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var bookListObservable: Observable<[String]> = self.bookList.asObservable()
    lazy var filterResultObservable: Observable<[String]> = self.filterResult.asObservable()
    
    let disposeBag = DisposeBag()
    
    var selectedString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTableView()
        setupSearchBar()
        setupRxSwiftTable()
        setupRxSwfitSearch()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
    //MARK: - Fake Data
    func setupData() {
        bookList.value.append("CS3217")
        bookList.value.append("NUS")
        bookList.value.append("HARRY PORTER")
        bookList.value.append("CS")
        bookList.value.append("SOC")
    }
    
    //MARK: - Setup TableView
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(BookShelfTableCell.self, forCellReuseIdentifier: tableViewCellID)
        
        view.addSubview(tableView)
    }
    
    //MARK: - Setup Search Bar
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - Setup RxSwift Table
    func setupRxSwiftTable() {
        filterResult.asObservable().bind(to: tableView.rx.items(cellIdentifier: tableViewCellID, cellType: BookShelfTableCell.self)) {
            (row, element, cell) in
            cell.titleLabel.text = element
            }.disposed(by: disposeBag)
        
        //Action after an element in datamModel is selected
        tableView.rx.modelSelected(String.self).subscribe(onNext:  { element in
            print("Model Value Received: \(element)")
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            
            //Pass String to ItemDetail ViewController
            self.selectedString = element
            self.performSegue(withIdentifier: "FavouriteToItemDetail", sender: self)
            
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Setup RxSwift Search
    func setupRxSwfitSearch() {
        let searchBar = searchController.searchBar
        searchBar.rx.text.orEmpty.distinctUntilChanged().debug().bind(to: searchValue).disposed(by: disposeBag)
        
        searchValueObservable.subscribe(onNext: { (value) in
            print("Search value received: \(value)")
            self.bookListObservable.map({$0.filter({text in
                if value.isEmpty {return true}
                return text.lowercased().contains(value.lowercased())
            })
            }).bind(to: self.filterResult).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Perform Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemDetailVC = segue.destination as? ItemDetailViewController {
            itemDetailVC.selectedString = selectedString
        }
    }
}
