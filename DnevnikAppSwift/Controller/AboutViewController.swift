//
//  AbiutViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 16.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class AboutViewController : UIViewController {
    @IBOutlet var aboutLabel : UILabel!
    override func viewDidLoad() {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("about", ofType: "txt")
        
        println("path = \(path)")
        
//        var error : NSError?
//        let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: error)
    }
}
