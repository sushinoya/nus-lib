//
//  ItemDetailViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class ItemDetailViewController: BaseViewController {
    
    var tableView: UITableView!
    let itemDetailTitlePictureTableCellID = "itemDetailTitlePictureTableCell"
    let itemDetailReviewTableCellID = "itemDetailReviewTableCell"
    let itemDetailSimilarBookTableCellID = "itemDetailSimilarBookTableCell"
    
    var selectedString: String?
    var itemToDisplay: BookItem?
    
    var favouriteButton: UIButton!
    
    var isFavourited: Bool = false
    
    var items: [[Any]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNavigationBar()
        setupTableView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    private func setupData() {
        
        let defaultBook = BookItem(name: "Title1", image: #imageLiteral(resourceName: "Sample5"))
        let reviews = ["ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview", "ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview"]
        
        let similarBoooks =  [[BookItem(name: "SimilarBook1", image: #imageLiteral(resourceName: "Sample5")),BookItem(name: "SimilarBook2", image: #imageLiteral(resourceName: "Sample8")),BookItem(name: "SimilarBook3", image: #imageLiteral(resourceName: "Sample1")),BookItem(name: "SimilarBook4", image: #imageLiteral(resourceName: "Sample2")),BookItem(name: "SimilarBook5", image: #imageLiteral(resourceName: "Sample5"))]]
        
        items = [[itemToDisplay ?? defaultBook] , reviews, similarBoooks]
    }
    
    private func setupNavigationBar() {
        favouriteButton = UIButton(type: .system)
        favouriteButton.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
        favouriteButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        favouriteButton.addTarget(self, action: #selector(addToFavouriteList), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        
        navigationItem.title = Constants.NavigationBarTitle.ItemDetailTitle
    }
 
    private func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ItemDetailTitlePictureTableCell.self, forCellReuseIdentifier: itemDetailTitlePictureTableCellID)
        tableView.register(ItemDetailReviewTableCell.self, forCellReuseIdentifier: itemDetailReviewTableCellID)
        tableView.register(ItemDetailSimilarBookTableCell.self, forCellReuseIdentifier: itemDetailSimilarBookTableCellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
    }
    
    @objc func addToFavouriteList() {
        if !isFavourited {
            print("Add to Favourite")
            favouriteButton.setImage(#imageLiteral(resourceName: "favourited"), for: .normal)
        } else {
            print("Remove from Favourite")
            favouriteButton.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
        }
        isFavourited = !isFavourited
    }
}



