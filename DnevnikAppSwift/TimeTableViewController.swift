//
//  TimeTableViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class TimeTableViewController : UITableViewController {
    var menuItems : [String] = ["cell1", "cell2", "cell3", "cell4", "cell5", "cell6", "cell7", "cell8"]
    var sectionItems : [String] = []
    
    var timeTable = [
        "2014-12-01, Пн": ["Русский язык", "Чтение", "Информатика"],
        "2014-12-02, Вт": ["Английский язык", "Физкультура", "Театр", "Чтение"]
                    ]
    @IBOutlet weak var sidebarButton : UIBarButtonItem!
    
    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButtonAction()

        sectionItems = timeTable.keys.array
    
    }
    
    func setupSideMenuAppearance() {
        view.backgroundColor = UIColor.darkGrayColor()
        tableView.backgroundColor = UIColor.darkGrayColor()
        tableView.separatorColor = UIColor.lightGrayColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.menuItems.count
        //return 4
        let sTitle = sectionItems[section]
        let rowsInSection : NSArray = timeTable[sTitle]!
        return rowsInSection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "cell"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        let sTitle = sectionItems[indexPath.section]
        let rowsInSection : NSArray = timeTable[sTitle]!
        let labelText = rowsInSection[indexPath.row] as String
        
        cell?.textLabel?.text = labelText
        return cell!
    }
/*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "cell"
        
        cellIdentifier = menuItems[indexPath.row]
        println(cellIdentifier)
        
//        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel.text = cellIdentifier
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        return cell!
    }
*/
/*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        headerLabel.font = UIFont(name: "boldSystemFont", size: 16)
//        headerLabel.text = "Понедельник, 01.12.2014"
        headerView.addSubview(headerLabel)
        
        return headerView
    }
*/
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionItems[section]
    }
}
