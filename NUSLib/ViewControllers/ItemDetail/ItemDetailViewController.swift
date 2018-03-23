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
    
    var items: [[Any]] = [
        [BookItem(name: "Title1", image: #imageLiteral(resourceName: "Sample5"))],
        ["ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview", "ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview"],
        [[BookItem(name: "SimilarBook1", image: #imageLiteral(resourceName: "Sample5")),BookItem(name: "SimilarBook2", image: #imageLiteral(resourceName: "Sample8")),BookItem(name: "SimilarBook3", image: #imageLiteral(resourceName: "Sample1")),BookItem(name: "SimilarBook4", image: #imageLiteral(resourceName: "Sample2")),BookItem(name: "SimilarBook5", image: #imageLiteral(resourceName: "Sample5"))]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    private func setupNavigationBar() {
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
}



