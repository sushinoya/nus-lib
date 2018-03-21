//
//  ItemDetailViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

enum TableViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

class ItemDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let titlePictureCellID = "titlePictureID"
    let reviewCellID = "reviewCellID"
    
    var selectedString: String?
    
    var items = [
        ["haha", "DSAD", "DSADfas"],
        ["DYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkasDYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkasDYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkasDYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkasDYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkasDYSADjdsakldjklsajdklasjdlkasjdlkasjdkljsadkljsakldjklsajdklajsdklasjdkljaskldjsakldjklsajdklasjdlkjasldkjsakldjlksajdlksajdlkas", "DSAdasdqweD", "eqweqwe", "DSDSADSADQWEQWE"],
        ["as", "qwe", "DSArqwrDfas","sadasldjlkasjd", "DASDAHSDKJHQIOWEO"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "HEADER"
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
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellID, for: indexPath) as! ReviewCell
            
            cell.reviewTextView.text = items[indexPath.section][indexPath.row]
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: titlePictureCellID, for: indexPath) as! TitlePictureCell
        
        cell.thumbImageView.image = #imageLiteral(resourceName: "Sample4")
        cell.titleLabel.text = items[indexPath.section][indexPath.row]
        cell.ratingLabel.text = "Rating for this book"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
            height = 200
        } else if indexPath.section == 1 {
            height = 100
        } else if indexPath.section == 2 {
            height = 50
        }
        return height
    }
    
    
}



