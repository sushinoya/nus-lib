//
//  ItemDetailViewController + TableView.swift
//  NUSLib
//
//  Created by Liang on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

enum ItemDetailTableSections: Int {
    case TitlePicture = 0
    case Review
    case SimilarBooks
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        let itemDetailTableSection:ItemDetailTableSections = ItemDetailTableSections(rawValue: section)!
        
        switch itemDetailTableSection {
        case .TitlePicture: label.text = "Book"
        case .Review: label.text = "Review"
        case .SimilarBooks: label.text = "Similar Books"
        }
        
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemDetailTableSection:ItemDetailTableSections = ItemDetailTableSections(rawValue: indexPath.section)!
        
        switch itemDetailTableSection {
        case .TitlePicture: return generateTableCellForTitlePicture(in: tableView, at: indexPath)
        case .Review: return generateTableCellForReview(in: tableView, at: indexPath)
        case .SimilarBooks: return  generateTableCellForSimilarBook(in: tableView, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemDetailTableSection:ItemDetailTableSections = ItemDetailTableSections(rawValue: indexPath.section)!
        var height:CGFloat = CGFloat()
        
        switch itemDetailTableSection {
        case .TitlePicture: height = view.frame.height * 0.25
        case .Review: height = view.frame.height * 0.25
        case .SimilarBooks: height = view.frame.height * 0.25
        }
        
        return height
    }
    
    private func generateTableCellForTitlePicture(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemDetailTitlePictureTableCellID, for: indexPath) as! ItemDetailTitlePictureTableCell
        let book = items[indexPath.section][indexPath.row] as! BookItem
        cell.thumbImageView.image = book.getThumbNail()
        cell.titleLabel.text = book.getTitle()
        cell.ratingLabel.text = "Rating for this book: \(book.getRating())"
        return cell
    }
    
    private func generateTableCellForReview(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemDetailReviewTableCellID, for: indexPath) as! ItemDetailReviewTableCell
        let reviewText = items[indexPath.section][indexPath.row] as! String
        cell.reviewTextView.text = reviewText
        return cell
    }
    
    private func generateTableCellForSimilarBook(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemDetailSimilarBookTableCellID, for: indexPath) as! ItemDetailSimilarBookTableCell
        let books = items[indexPath.section][indexPath.row] as! [BookItem]
        cell.books = books
        return cell
    }
}
