//
//  SidebarTableViewController.swift
//  NUSLib
//
//  Created by Suyash Shekhar on 7/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {
    
    @IBOutlet var accountActionLabel: UILabel!
    @IBOutlet var accountActionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginCellImageAndText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func setLoginCellImageAndText() {
        // if user is signed in:
        accountActionLabel.text = "User's name"
        accountActionImage.image = UIImage(named: "contact")
        
        // else:
        accountActionLabel.text = "Login"
        accountActionImage.image = UIImage(named: "account")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            sequeToAccountOrLogin()
        }
    }
    
    
    func sequeToAccountOrLogin() {
        // if user is signed in:
        performSegue(withIdentifier: "SidebarToAccountPage", sender: self)
        
        // else:
        performSegue(withIdentifier: "SidebarToLogin", sender: self)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
    // MARK: - Navigation to the Account Page

    // Seguing to the Account Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AccountPageViewController {
            // Send account details to account page?
            // Unless that is accessible from the account page
        }
    }

}
