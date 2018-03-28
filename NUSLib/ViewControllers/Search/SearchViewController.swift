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
    
    lazy var searchController: UISearchController = {[unowned self] in
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        return searchController
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(TopSeachTableCell.self, forCellReuseIdentifier: topSeachTableCellID)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var isFiltering: Bool = false
    

    let topSeachTableCellID = "topSeachTableCell"
    
    var searchValue: Variable<String> = Variable("")
    var topSearchList: Variable<[String]> = Variable([])
    var filterResult: Variable<[String]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var topSearchListObservable: Observable<[String]> = self.topSearchList.asObservable()
    lazy var filterResultObservable: Observable<[String]> = self.filterResult.asObservable()
    
    var selectedString: String?
    var selectedItem: BookItem?
    
    let api = CentralLibrary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRxSwiftTable()
        self.definesPresentationContext = true;
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.SearchTitle
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupRxSwiftTable() {
        
        searchController.searchBar.rx.text.orEmpty.debounce(0.5, scheduler: MainScheduler.instance).distinctUntilChanged().asObservable()
            .map { ($0 ).lowercased() }
            .flatMapLatest { request -> Observable<[BookItem]> in
                return self.api.getBooksFromKeyword(keyword: request)
            }
            .bind(to: tableView.rx.items(cellIdentifier: topSeachTableCellID, cellType: TopSeachTableCell.self)) { index, model, cell in
                cell.topSearchLabel.text = model.getTitle()
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(BookItem.self).subscribe(onNext:  { model in
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            
            //Pass String to ItemDetail ViewController
            self.selectedString = model.getTitle()
            self.selectedItem = model
            
            self.performSegue(withIdentifier: "SearchToItemDetail", sender: self)
            
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemDetailVC = segue.destination as? ItemDetailViewController {
            // MARK: - TODO: Pass an item to ItemDetailViewController
            itemDetailVC.selectedString = "selectedString"
            itemDetailVC.itemToDisplay = selectedItem
        }
    }
}

