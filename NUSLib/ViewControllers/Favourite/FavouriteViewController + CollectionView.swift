//
//  FavouriteViewController + CollectionView.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension FavouriteViewController {
    // RAReorderableLayout delegate datasource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.frame.size.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        if indexPath.section == 0 {
            return CGSize(width: threePiecesWidth, height: threePiecesWidth)
        }else {
            return CGSize(width: twoPiecesWidth, height: twoPiecesWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemDisplayCell
        
        if indexPath.section == 0 {
            let book = objectForSection0(at: indexPath)
            cell.imageView.image = book.getThumbNail()
            cell.backgroundColor = UIColor.blue
            cell.titleLabel.text = book.getTitle()
        } else {
            let book = objectForSection1(at: indexPath)
            cell.imageView.image = book.getThumbNail()
            cell.backgroundColor = UIColor.yellow
            cell.titleLabel.text = book.getTitle()

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        if collectionView.numberOfItems(inSection: indexPath.section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, willMoveTo toIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var book: BookItem
        if atIndexPath.section == 0 {
            book = bookListForSection0.remove(at: atIndexPath.item)
        }else {
            book = bookListForSection1.remove(at: atIndexPath.item)
        }
        
        if toIndexPath.section == 0 {
            bookListForSection0.insert(book, at: toIndexPath.item)
        }else {
            bookListForSection1.insert(book, at: toIndexPath.item)
        }
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            return 0.3
        }
    }
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0)
    }
    
    //MARK: - Add Search Bar
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    // MARK: UISearchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchTerm: searchText)
        collectionview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
    filter(searchTerm: "")
       collectionview.reloadData()
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
