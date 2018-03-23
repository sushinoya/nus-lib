//
//  FavouriteTableViewController + Search.swift
//  NUSLib
//
//  Created by Liang on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension FavouriteTableViewController: UISearchBarDelegate {
    // MARK: UISearchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchTerm: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        filter(searchTerm: "")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
