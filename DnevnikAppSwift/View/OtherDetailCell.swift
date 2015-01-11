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
    
    func configureFor(lesson : DnevnikLesson, key: String, val: String, type : cellType) {
        super.configureFor()
        keyLabel.text = ""
        valLabel.text = ""
        
        keyView.backgroundColor = nil
        keyLabel.textColor = UIColor.whiteColor()

        keyLabel.text = key
        valLabel.text = val
        if type == .homeWorkType {
            //if lesson.homeworkState != "" {
            if key != "" {
                keyView.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
            }
            //keyLabel.text = key //lesson.homeworkState
            //valLabel.text = val //lesson.homeworkText
        } else if type == .marksType {
            keyLabel.text = key //lesson.marks[i]
            valLabel.text = val //lesson.marksComments[i]
            keyLabel.font = UIFont.boldSystemFontOfSize(20)
            switch key {
            case "4", "5" :
                keyView.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1) //.greenColor()
            case "3" :
                keyView.backgroundColor = UIColor(red: 249/255, green: 162/255, blue: 59/255, alpha: 1) //.orangeColor()
            case "2" :
                keyView.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1) //.redColor()
            default :
                keyView.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1)
            }
        } else if type == .availType {
            //switch lesson.availability {
            switch lesson.avail.color {
            case "G" :
                keyView.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1)
            case "B" :
                keyView.backgroundColor = UIColor(red: 69/255, green: 157/255, blue: 214/255, alpha: 1)
            case "R" :
                keyView.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
            default :
                keyView.backgroundColor = nil
            }
        }
        valLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping// (rawValue: 0)!
        valLabel.preferredMaxLayoutWidth = 229
        valLabel.numberOfLines = 0
        valLabel.sizeToFit()
    }
}