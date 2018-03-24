//
//  FavouriteTableViewController + TableView.swift
//  NUSLib
//
//  Created by Liang on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension FavouriteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if section == 0 {
                return filteredBookListForSecion0.count
            }else {
                return filteredBookListForSecion1.count
            }
        } else {
            if section == 0 {
                return bookListForSection0.count
            }else {
                return bookListForSection1.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookTableViewCellID, for: indexPath) as! BookTableViewCell
        
        let book = getBookItem(at: indexPath)
        cell.thumbImageView.image = book.getThumbNail()
        cell.titleLabel.text = book.getTitle()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    /*
        Set to true so that the cell can move
     */
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
        Move the cell from sourceIndexPath to destinationIndexPath
     */
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var book: BookItem
        if sourceIndexPath.section == 0 {
            book = bookListForSection0.remove(at: sourceIndexPath.row)
        }else {
            book = bookListForSection1.remove(at: sourceIndexPath.row)
        }
        
        if destinationIndexPath.section == 0 {
            bookListForSection0.insert(book, at: destinationIndexPath.row)
        }else {
            bookListForSection1.insert(book, at: destinationIndexPath.row)
        }
    }
}
