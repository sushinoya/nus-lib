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

class SearchViewController: UIViewController {
    
    var searchController: UISearchController!
    
    var tableView: UITableView!
    let tableViewCellID = "tableViewCellID"
    
    var searchValue: Variable<String> = Variable("")
    var topSearchList: Variable<[String]> = Variable([])
    var filterResult: Variable<[String]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var topSearchListObservable: Observable<[String]> = self.topSearchList.asObservable()
    lazy var filterResultObservable: Observable<[String]> = self.filterResult.asObservable()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        setupTableView()
        setupSearchBar()
        
        filterResultObservable.asObservable().bind(to: tableView.rx.items(cellIdentifier: tableViewCellID, cellType: TopSeachTableCell.self)) {
            (row, element, cell) in
            cell.topSearchLabel.text = element
        }.disposed(by: disposeBag)
        
        //Action after an element in datamModel is selected
        tableView.rx.modelSelected(String.self).subscribe(onNext:  { element in
                print(element)
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }).disposed(by: disposeBag)
        
        
        let searchBar = searchController.searchBar
        searchBar.rx.text.orEmpty.distinctUntilChanged().debug().bind(to: searchValue).disposed(by: disposeBag)

        topSearchListObservable.subscribe(onNext: { (value) in
            print(value)
        }).disposed(by: disposeBag)
        
        searchValueObservable.subscribe(onNext: { (value) in
            print("Search value received: \(value)")
            
            self.topSearchListObservable.map({$0.filter({text in
                if value.isEmpty {return true}
                return text.lowercased().contains(value.lowercased())
            })
            }).bind(to: self.filterResult).disposed(by: self.disposeBag)

            
        }).disposed(by: disposeBag)
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
        
        view.addSubview(tableView)
    }
    
    //MARK: - Setup Search Bar
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        tableView.tableHeaderView = searchController.searchBar
    }
    
}




