//
//  SidebarViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class SidebarViewController : UITableViewController {
    var menuItems : [String] = ["Login Page", "Marks", "TimeTable"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        setupSideMenuAppearance()
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    func setupSideMenuAppearance() {
        view.backgroundColor = UIColor.darkGrayColor()
        tableView.backgroundColor = UIColor.darkGrayColor()
        tableView.separatorColor = UIColor.lightGrayColor()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.menuItems.count
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "cell"

        cellIdentifier = menuItems[indexPath.row]
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if !Global.signedIn && identifier != "showLoginPage" {
            return false
        }
        return true
    }
    
    
}
