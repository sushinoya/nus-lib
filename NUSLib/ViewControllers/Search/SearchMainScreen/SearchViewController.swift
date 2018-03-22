//
//  SearchViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    
    var searchController: NoCancelButtonSearchController!
    var isFiltering: Bool = false
    
    var tableView: UITableView!
    let tableViewCellID = "tableViewCellID"
    
    var searchValue: Variable<String> = Variable("")
    var topSearchList: Variable<[String]> = Variable([])
    var filterResult: Variable<[String]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var topSearchListObservable: Observable<[String]> = self.topSearchList.asObservable()
    lazy var filterResultObservable: Observable<[String]> = self.filterResult.asObservable()
    
    var selectedString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        setupData()
        setupTableView()
        setupSearchBar()
        setupRxSwiftTable()
        setupRxSwfitSearch()
        self.definesPresentationContext = true;

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    

    //MARK: - Fake Data
    func setupData() {
        topSearchList.value.append("CS3217")
        topSearchList.value.append("NUS")
        topSearchList.value.append("HARRY PORTER")
        topSearchList.value.append("CS")
        topSearchList.value.append("SOC")
    }
    
    //MARK: - Setup TableView
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(TopSeachTableCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
    }
    
    //MARK: - Setup Search Bar
    func setupSearchBar() {
        searchController = NoCancelButtonSearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.tintColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - Setup RxSwift Table
    func setupRxSwiftTable() {
        filterResult.asObservable().bind(to: tableView.rx.items(cellIdentifier: tableViewCellID, cellType: TopSeachTableCell.self)) {
            (row, element, cell) in
            cell.topSearchLabel.text = element
            }.disposed(by: disposeBag)
        
        //Action after an element in datamModel is selected
        tableView.rx.modelSelected(String.self).subscribe(onNext:  { element in
            print("Model Value Received: \(element)")
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            
            //Pass String to ItemDetail ViewController
            self.selectedString = element
            
            self.performSegue(withIdentifier: "SearchToItemDetail", sender: self)
            
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Setup RxSwift Search
    func setupRxSwfitSearch() {
        searchController.searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: searchValue).disposed(by: disposeBag)
    
        searchValueObservable.subscribe(onNext: { (value) in
            print("Search value received: \(value)")
            self.topSearchListObservable.map({$0.filter({text in
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


class NoCancelButtonSearchController: UISearchController {
    let noCancelButtonSearchBar = NoCancelButtonSearchBar()
    override var searchBar: UISearchBar { return noCancelButtonSearchBar }
}

class NoCancelButtonSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) { /* void */ }
}



