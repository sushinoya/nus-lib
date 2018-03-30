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
    
    lazy var searchController: NoCancelButtonSearchController = {[unowned self] in
        let searchController = NoCancelButtonSearchController(searchResultsController: nil)
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
    var topSearchList: Variable<[BookItem]> = Variable([])
    var filterResult: Variable<[BookItem]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var topSearchListObservable: Observable<[BookItem]> = self.topSearchList.asObservable()
    lazy var filterResultObservable: Observable<[BookItem]> = self.filterResult.asObservable()
    
    var selectedString: String?
    var selectedItem: BookItem?
    
    let api = CentralLibrary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupData()
        setupRxSwfitSearch()
        self.definesPresentationContext = true;
    }
    
    private func setupData() {
        
        topSearchList.value.append(BookItem(name: "CS3217", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(name: "NUS", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(name: "HARRY", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(name: "CO", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(name: "PSD", image: #imageLiteral(resourceName: "Sample9")))
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
        let filterButton = UIButton(type: .system)
        filterButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        filterButton.addTarget(self, action: #selector(performFilter), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        navigationItem.title = Constants.NavigationBarTitle.SearchTitle
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    /*
        SearchBar input will be stored into searchValue
        searchValueObservable will listen to the searchValue change
        When there is a change in the searchValue, either topSearchListObservable will be stored into filterResultBook or the result fetched from database
        Filterresultbook will then bind the data to table
     */
    func setupRxSwfitSearch() {
    
        searchController.searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: searchValue).disposed(by: disposeBag)
        
        searchValueObservable.subscribe(onNext: { [unowned self] (value) in
            if value.isEmpty {
               self.topSearchListObservable.bind(to: self.filterResult).disposed(by: self.disposeBag)
            } else {
                self.searchValueObservable.map { $0.lowercased() }
                .debounce(0.5, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .distinctUntilChanged()
                .asObservable()
                .distinctUntilChanged()
                .flatMapLatest { request -> Observable<[BookItem]> in
                    return self.api.getBooksFromKeyword(keyword: request, limit: 5)
                }.bind(to: self.filterResult).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        filterResultObservable.bind(to: tableView.rx.items(cellIdentifier: topSeachTableCellID, cellType: TopSeachTableCell.self)) { index, model, cell in
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
    
    @objc func performFilter() {
        print(filterResult.value)
        filterResult.value.sort(by: {$0.getTitle() < $1.getTitle()})
    }
}

class NoCancelButtonSearchController: UISearchController {
    let noCancelButtonSearchBar = NoCancelButtonSearchBar()
    override var searchBar: UISearchBar { return noCancelButtonSearchBar }
}

class NoCancelButtonSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) { /* void */ }
}
