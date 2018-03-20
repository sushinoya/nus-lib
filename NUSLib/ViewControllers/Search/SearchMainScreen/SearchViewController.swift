//
//  SearchViewController.swift
//  NUSLib
//
//  Created by wongkf on 20/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Search Bar
    var searchBar: UISearchBar!
    
    var tableView: UITableView!
    let tableViewCellID = "tableViewCellID"
    
    var topSearchList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        view.addSubview(searchBar)
        
        setupData()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.anchorToEdge(.top, padding: 20, width: view.frame.width, height: 60)
        tableView.alignAndFill(align: .underCentered, relativeTo: searchBar, padding: 0, offset: 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    

    //MARK: - Fake Data
    func setupData() {
        topSearchList.append("CS3217")
        topSearchList.append("NUS")
        topSearchList.append("HARRY PORTER")
        topSearchList.append("CS")
        topSearchList.append("SOC")
    }
    
    //MARK: - Setup TableView
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame, style: .plain)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TopSeachTableCell.self, forCellReuseIdentifier: tableViewCellID)
        
        view.addSubview(tableView)
    }
    
}


class TopSeachTableCell: UITableViewCell {
    
    var topSearchLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        topSearchLabel.frame = bounds
        topSearchLabel.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: self.width)
    }
    
    
    func setupViews() {
        topSearchLabel = UILabel()
        topSearchLabel.textAlignment = .center
        contentView.addSubview(topSearchLabel)
    }
    
}

