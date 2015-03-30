//
//  SidebarViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class SidebarViewController : UITableViewController {
    var menuItems : [String] = ["Login Page", "Marks", "TimeTable", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.currentDevice().model.rangeOfString("Simulator", options: nil, range: nil, locale: nil) == nil)
        {
           // menuItems = ["Login Page", "Marks", "About"]
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        setupSideMenuAppearance()
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    func setupSideMenuAppearance() {
        //view.backgroundColor = UIColor.greenColor() //darkGrayColor()
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
        return self.menuItems.count
        //return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "cell"

        cellIdentifier = menuItems[indexPath.row]
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.darkGrayColor()
        //cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if !Global.signedIn && identifier != "showLoginPage" && identifier != "showTable" {
            return false
        }
        return true
    }
    
    
}
