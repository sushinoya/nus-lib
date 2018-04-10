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
        return bookLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredLists[section].count
        } else {
            return bookLists[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookTableViewCellID, for: indexPath) as! BookTableViewCell
        
        let book = getBookItem(at: indexPath)        
        cell.textLabel?.text = book.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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
        let book = bookLists[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        bookLists[destinationIndexPath.section].insert(book, at: destinationIndexPath.item)
    }

}
