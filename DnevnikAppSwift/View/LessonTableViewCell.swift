//
//  DetailCell.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 15.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class LessonTableViewCell : UITableViewCell {
    
    func configureFor() {
        self.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = UIColor(red: 219/255, green: 226/255, blue: 230/255, alpha: 0.6)
        
    }
}