//
//  LessonCell.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 07.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class LessonCell : UITableViewCell {
    @IBOutlet weak var availableView : UIView!
    @IBOutlet weak var subjectLabel : UILabel!
    @IBOutlet weak var mark1View : UIView!
    @IBOutlet weak var mark1Label : UILabel!
    @IBOutlet weak var mark2View : UIView!
    @IBOutlet weak var mark2Label : UILabel!
    @IBOutlet var homeWorkImage : UIImageView!
//    @IBOutlet weak var homeWorkView : UIView!
    
    func configureFor(lesson : DnevnikLesson) {
        mark1Label.text = ""
        mark2Label.text = ""
        mark1View.backgroundColor = UIColor.whiteColor()
        mark2View.backgroundColor = UIColor.whiteColor()
        availableView.backgroundColor = UIColor.whiteColor()
        
        if lesson.homework == true {
            //var point = CGPoint(x: self.frame.origin.x + self.frame.width - 20, y: 17)
            //var size = CGSize(width: 10, height: 10)
            //var frame = CGRect(origin: point, size: size)
            //var v = UIImageView(frame: frame) //UIView(frame: frame)
            //v.image = UIImage(named: "circle_red_16_ns")
            //v.tintColor = UIColor.greenColor()
            //self.addSubview(v)
            self.homeWorkImage.image = UIImage(named: "circle_red_16_ns")
        } else {
            self.homeWorkImage.image = nil
        }
        
        switch lesson.availability {
        case "G" :
            availableView.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1)
        case "B" :
            availableView.backgroundColor = UIColor(red: 69/255, green: 157/255, blue: 214/255, alpha: 1)
        case "R" :
            availableView.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        default :
            availableView.backgroundColor = UIColor.whiteColor()
        }
        
        subjectLabel.text = lesson.subjectName
        subjectLabel.textColor = UIColor(red: 34/255, green: 145/255, blue: 190/255, alpha: 1)
        subjectLabel.font = UIFont.boldSystemFontOfSize(18)
        
        var lbl : UILabel
        var view : UIView
        if lesson.marks.count > 0 {
            for i in 0...lesson.marks.count - 1 {
                if i >= 2 {
                    break
                }
                //
                if i == 0 {
                    view = mark1View
                    lbl = mark1Label
                } else {
                    view = mark2View
                    lbl = mark2Label
                }
                //
                switch lesson.marks[i] {
                case "4", "5" :
                    view.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1) //.greenColor()
                case "3" :
                    view.backgroundColor = UIColor(red: 249/255, green: 162/255, blue: 59/255, alpha: 1) //.orangeColor()
                case "2" :
                    view.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1) //.redColor()
                default :
                    view.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1)
                }
                lbl.text = lesson.marks[i]
            }
            
            
        }
    }

}
