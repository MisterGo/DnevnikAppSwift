//
//  OtherDetail.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 14.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class OtherDetailCell : LessonTableViewCell {
    @IBOutlet var keyView : UIView!
    @IBOutlet var keyLabel : UILabel!
    @IBOutlet var valLabel : UILabel!
    
    enum cellType {
        case homeWorkType
        case availType
        case marksType
    }
    
    func configureFor(lesson : DnevnikLesson, type : cellType) {
        super.configureFor()
        keyLabel.text = ""
        valLabel.text = ""
        
        keyView.backgroundColor = nil
        if type == .homeWorkType {
        if lesson.homeworkState != "" {
            keyView.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        }
        keyLabel.text = lesson.homeworkState
        keyLabel.textColor = UIColor.whiteColor()
        valLabel.text = lesson.homeworkText
        }
        valLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping// (rawValue: 0)!
        valLabel.preferredMaxLayoutWidth = 229
        valLabel.numberOfLines = 0
        valLabel.sizeToFit()
    }
}