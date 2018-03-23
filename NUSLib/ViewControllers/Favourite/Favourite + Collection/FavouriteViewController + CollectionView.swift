//
//  FavouriteCollectionViewController + CollectionView.swift
//  NUSLib
//
//  Created by Liang on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

extension FavouriteCollectionViewController: UICollectionViewDelegateFlowLayout {

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCollectionViewCell
        
        let book = getBookItem(at: indexPath)
        cell.imageView.image = book.getThumbNail()
        cell.titleLabel.text = book.getTitle()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var book: BookItem
        if sourceIndexPath.section == 0 {
            book = bookListForSection0.remove(at: sourceIndexPath.item)
        }else {
            book = bookListForSection1.remove(at: sourceIndexPath.item)
        }

        if destinationIndexPath.section == 0 {
            bookListForSection0.insert(book, at: destinationIndexPath.item)
        }else {
            bookListForSection1.insert(book, at: destinationIndexPath.item)
        }
    }

}
