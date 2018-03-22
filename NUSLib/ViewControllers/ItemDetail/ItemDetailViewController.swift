//
//  ItemDetailViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

enum TableViewModelItemType {
    case TitlePicture
    case Review
    case SimilarBook
}

class ItemDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let titlePictureCellID = "titlePictureID"
    let reviewCellID = "reviewCellID"
    let similarBookCellID = "similarBookCellID"
    
    var selectedString: String?
    
    var items: [[Any]] = [
        [BookItem(name: "Title1", image: #imageLiteral(resourceName: "Sample5"))],
        ["ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview", "ReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReviewReview"],
        [[BookItem(name: "SimilarBook1", image: #imageLiteral(resourceName: "Sample5")),BookItem(name: "SimilarBook2", image: #imageLiteral(resourceName: "Sample8")),BookItem(name: "SimilarBook3", image: #imageLiteral(resourceName: "Sample1")),BookItem(name: "SimilarBook4", image: #imageLiteral(resourceName: "Sample2")),BookItem(name: "SimilarBook5", image: #imageLiteral(resourceName: "Sample5"))]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Item Detail"
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.anchorToEdge(.top, padding: 0, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
 
    //MARK: - Setup TableView
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitlePictureCell.self, forCellReuseIdentifier: titlePictureCellID)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: reviewCellID)
        tableView.register(SimilarBookCell.self, forCellReuseIdentifier: similarBookCellID)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.text = "Book"
        } else if section == 1 {
            label.text = "Review"
        } else {
            label.text = "similar Book"
        }
        label.backgroundColor = UIColor.gray
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: titlePictureCellID, for: indexPath) as! TitlePictureCell
            
            let book = items[indexPath.section][indexPath.row] as! BookItem
            cell.thumbImageView.image = book.getThumbNail()
            cell.titleLabel.text = book.getTitle()
            cell.ratingLabel.text = "Rating for this book: \(book.getRating())"
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellID, for: indexPath) as! ReviewCell
            
            let reviewText = items[indexPath.section][indexPath.row] as! String
            
            cell.reviewTextView.text = reviewText
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: similarBookCellID, for: indexPath) as! SimilarBookCell
        
        let books = items[indexPath.section][indexPath.row] as! [BookItem]
        cell.data = books
        return cell
 
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
            height = view.frame.height * 0.25
        } else if indexPath.section == 1 {
            height = view.frame.height * 0.25
        } else if indexPath.section == 2 {
            height = view.frame.height * 0.25
        }
        return height
    }
    
    
}



