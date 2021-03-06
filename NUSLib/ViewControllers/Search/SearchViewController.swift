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

/*
    The controller manages the UI for Search Page. Allowing user to search book title.
 */

class SearchViewController: BaseViewController {

    // MARK: - Variables
    var topSearchCollectionViewCellID = "topSearchCollectionViewCell"

    var searchValue: Variable<String> = Variable("")
    var filterResult: Variable<[DisplayableItem]> = Variable([])
    var searchResult: Variable<[DisplayableItem]> = Variable([])

    let api = CentralLibrary()
    let filterLauncher = FilterLauncher()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        addSubviews()
        setupRxSwfitSearch()
        self.definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.resignFirstResponder()
    }

    /*
        It set up Navigation Bar to be displayed in this view
     */
    func setupNavigationBar() {
        let sortButton = UIButton(type: .system)

        sortButton.setImage( UIImage.fontAwesomeIcon(name: .sortAlphaAsc, textColor: UIColor.blue, size: CGSize(width: 34, height: 34)), for: .normal)
        sortButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        sortButton.addTarget(self, action: #selector(performSort), for: .touchUpInside)

        let filterButton = UIButton(type: .system)
        filterButton.setImage( UIImage.fontAwesomeIcon(name: .filter, textColor: UIColor.blue, size: CGSize(width: 34, height: 34)), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        filterButton.addTarget(self, action: #selector(performFilter), for: .touchUpInside)

        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: sortButton), UIBarButtonItem(customView: filterButton)]

        navigationItem.title = Constants.NavigationBarTitle.SearchTitle
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.anchorToEdge(.top, padding: 60, width: view.frame.width, height: view.frame.height)
    }

    // MARK: - Lazy initialisation views

    /*
     It set up UI subviews to be displayed in this view
     */
    private func addSubviews() {
        view.addSubview(collectionView)
        collectionView.addSubview(searchController.searchBar)
    }

    lazy var searchController: NoCancelButtonSearchController = {[unowned self] in
        let searchController = NoCancelButtonSearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.blue
        searchController.searchBar.tintColor = UIColor.blue
        searchController.searchBar.placeholder = "Please Enter"
        return searchController
        }()

    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: view.frame.width / 2.0 - 40, height: 170)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 40)
        let collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionview.register(TopSeachCollectionViewCell.self, forCellWithReuseIdentifier: topSearchCollectionViewCellID)
        collectionview.backgroundColor = UIColor.white
        return collectionview
        }()

    // MARK: - Helper methods

    /*
     It set up Reactive Search which allowing user to query library api "as-user-is-typing"
     */
    func setupRxSwfitSearch() {

        //Perform search based on searchBar text
        searchController.searchBar.rx.text
            .orEmpty
            .map { $0.isEmpty ? "top" : $0.lowercased() }
            .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .distinctUntilChanged()
            .flatMapLatest { self.api.getBooks(byTitle: $0)}
            .map { $0.map { $0 as DisplayableItem }}
            .bind(to: self.searchResult)
            .disposed(by: self.disposeBag)
        
        //Then bind search result obtained from Library API to collectionView
        searchResult.asObservable().bind(to: collectionView.rx.items(cellIdentifier: topSearchCollectionViewCellID, cellType: TopSeachCollectionViewCell.self)) {index, model, cell in
            cell.topSearchLabel.text = model.title
            cell.author.text = model.author
            }
            .disposed(by: disposeBag)

        //Now when the cell is selected, navigate to ItemDetail
        collectionView.rx.modelSelected(BookItem.self).subscribe(onNext: {
            model in

            if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first {
                self.collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }
            self.state?.itemDetail = model
            self.performSegue(withIdentifier: "SearchToItemDetail", sender: self)

        }).disposed(by: disposeBag)

    }

    /*
     It sort the searched result by title in alphabetically order
     */
    @objc func performSort() {
        searchResult.value.sort(by: {$0.title! < $1.title!})
    }

    /*
     It filter the searched result by certain criteria. Eg. title length
     */
    @objc func performFilter() {
        //When user is searching, then need to reset filterResult value
        //Else, user is just trying to filter current searchResult

        filterResult.value = searchResult.value
        searchController.searchBar.resignFirstResponder()
        filterLauncher.delegate = self
        filterLauncher.showFilters()
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToItemDetail" {
            if let vc = segue.destination as? BaseViewController {
                vc.state = state
            }
        }
    }
}

//Mark: - FilterLauncherDelegate
extension SearchViewController: FilterLauncherDelegate {
    /*
     It filter the searched result such that only title length less than the user-specified value will be displayed
     */
    func filterByTitle(_ length: Int) {
        let temp = filterResult.value
        searchResult.value = filterResult.value.filter({
            print(length, print($0.title!.count))
            return $0.title!.count <= length
        })
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
