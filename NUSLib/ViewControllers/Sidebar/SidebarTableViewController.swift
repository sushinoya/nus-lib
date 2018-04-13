//
//  SidebarTableViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {
    
    //MARK: - Variables

    @IBOutlet var accountActionLabel: UILabel!
    @IBOutlet var accountActionImage: UIImageView!
    let dataSource = FirebaseDataSource()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginCellImageAndText()
    }
    
    //MARK: - Helper methods
    func setLoginCellImageAndText() {
        if let user = dataSource.getCurrentUser() {
            accountActionLabel.text = user.getUsername()
            accountActionImage.image = UIImage(named: "contact")
        } else {
            accountActionLabel.text = "Login"
            accountActionImage.image = UIImage(named: "account")
        }
    }

    func sequeToAccountOrLogin() {
        if dataSource.isUserSignedIn() {
            performSegue(withIdentifier: "SidebarToAccountPage", sender: self)
        } else {
            performSegue(withIdentifier: "SidebarToLogin", sender: self)
        }
    }


    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BaseViewController {
            vc.state = StateController()
        }
    }

}

extension SidebarTableViewController {
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            sequeToAccountOrLogin()
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
