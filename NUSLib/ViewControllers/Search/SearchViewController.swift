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
    

    let topSeachTableCellID = "topSeachTableCell"
    
    var searchValue: Variable<String> = Variable("")
    var topSearchList: Variable<[DisplayableItem]> = Variable([])
    var filterResult: Variable<[DisplayableItem]> = Variable([])
    var searchResult: Variable<[DisplayableItem]> = Variable([])
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var topSearchListObservable: Observable<[DisplayableItem]> = self.topSearchList.asObservable()
    lazy var filterResultObservable: Observable<[DisplayableItem]> = self.filterResult.asObservable()
    lazy var searchResultObservable: Observable<[DisplayableItem]> = self.searchResult.asObservable()
    
    var selectedString: String?
    var selectedItem: DisplayableItem?
    
    var isSearching = false
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
        /*
        topSearchList.value.append(BookItem(id: "nil", name: "CS3217", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(id: "nil", name: "NUS", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(id: "nil", name: "HARRY", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(id: "nil", name: "C2222O", image: #imageLiteral(resourceName: "Sample9")))
        topSearchList.value.append(BookItem(id: "nil", name: "PSD4444444", image: #imageLiteral(resourceName: "Sample9")))*/
        
        topSearchList.value.append(BookItem {
            $0.id = "0001"
            $0.title = "CS3217"
            $0.author = "Ben Leong"
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func setupNavigationBar() {
        let sortButton = UIButton(type: .system)
       
        sortButton.setImage( UIImage.fontAwesomeIcon(name: .sortAlphaAsc, textColor: UIColor.blue , size: CGSize(width: 34, height: 34)), for: .normal)
        sortButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        sortButton.addTarget(self, action: #selector(performSort), for: .touchUpInside)
        
        let filterButton = UIButton(type: .system)
        filterButton.setImage( UIImage.fontAwesomeIcon(name: .filter, textColor: UIColor.blue , size: CGSize(width: 34, height: 34)), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        filterButton.addTarget(self, action: #selector(performFilter), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: sortButton), UIBarButtonItem(customView: filterButton)]
        
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
            self.isSearching = true
            if value.isEmpty {
               self.topSearchListObservable.bind(to: self.searchResult).disposed(by: self.disposeBag)
            } else {
                self.searchValueObservable
                    .map { $0.lowercased() }
                    .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                    .distinctUntilChanged()
                    .asObservable()
                    .flatMapLatest { request -> Observable<[BookItem]> in
                        return self.api.getBooks(byTitle: request)
                    }
                    .map{ $0.map{ $0 as DisplayableItem }}
                    .bind(to: self.searchResult)
                    .disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        searchResultObservable.bind(to: tableView.rx.items(cellIdentifier: topSeachTableCellID, cellType: TopSeachTableCell.self)) { index, model, cell in
            cell.topSearchLabel.text = model.title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(BookItem.self).subscribe(onNext:  { model in
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            
            //Pass String to ItemDetail ViewController
            self.selectedString = model.title
            self.selectedItem = model
            
            self.performSegue(withIdentifier: "SearchToItemDetail", sender: self)
            
        }).disposed(by: disposeBag)
    }
    
    @objc func performSort() {
        searchResult.value.sort(by: {$0.title! < $1.title!})
        print(searchResult.value)
    }
    
    let filterLauncher = FilterLauncher()
    
    @objc func performFilter() {
        //When user is searching, then need to reset filterResult value
        //Else, user is just trying to filter current searchResult
        if isSearching {
            filterResult.value = searchResult.value
            isSearching = false
        }
        
        searchController.searchBar.resignFirstResponder()
        filterLauncher.delegate = self
        filterLauncher.showFilters()
    }

}

extension SearchViewController: FilterLauncherDelegate {
    func update(text: Int) {
        let temp = filterResult.value
        searchResult.value = filterResult.value.filter({$0.title!.count <= text})
        filterResult.value = temp
    }
}

class NoCancelButtonSearchController: UISearchController {
    let noCancelButtonSearchBar = NoCancelButtonSearchBar()
    override var searchBar: UISearchBar { return noCancelButtonSearchBar }
}

class NoCancelButtonSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) { /* void */ }
}

