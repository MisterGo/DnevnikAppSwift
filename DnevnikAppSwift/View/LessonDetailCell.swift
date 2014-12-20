//
//  LessonDetail.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 14.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class LessonDetailCell : LessonTableViewCell {
    
    @IBOutlet var keyLabel : UILabel!
    @IBOutlet var valLabel : UILabel!
    
    func configureFor(key : String, value : String) {
        super.configureFor()
        keyLabel.text = key
        valLabel.text = value
        valLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping //(rawValue: 0)!
        valLabel.preferredMaxLayoutWidth = 229
        valLabel.numberOfLines = 0
        valLabel.sizeToFit()
    }
}