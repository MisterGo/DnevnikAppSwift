//
//  AboutController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 10.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class AboutController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var aboutLabel : UILabel!
    @IBOutlet weak var sidebarButton : UIBarButtonItem!

    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            //sidebarButton.tintColor = UIColor.darkGrayColor()
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButtonAction()
        
//        let bundle = NSBundle.mainBundle()
//        let path = bundle.pathForResource("about", ofType: "txt")
//        var error : NSError?
//        var content = String(format: path!, locale: nil, error!)
        
//        println("cont = \(content)")

    }
}
