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
        // приходится тупо закрашивать белым прямоугольником
        let xx = subjectLabel.frame.origin.x + subjectLabel.frame.width
        var point = CGPoint(x: xx, y: 4)
        var size = CGSize(width: self.frame.width - xx - 20, height: 36)
        var frame = CGRect(origin: point, size: size)
        var v = UIView(frame: frame)
        v.backgroundColor = UIColor.whiteColor()
        self.addSubview(v)
        
        mark1Label.text = ""
        mark2Label.text = ""
        mark1View.backgroundColor = UIColor.whiteColor()
        mark2View.backgroundColor = UIColor.whiteColor()
        availableView.backgroundColor = UIColor.whiteColor()
        
        var subViewX = self.frame.origin.x + self.frame.width - 25

        //if lesson.homework == true {
        if lesson.homeworks.count > 0 {
            self.homeWorkImage.image = UIImage(named: "circle_red_16_ns")
        } else {
            self.homeWorkImage.image = nil
        }
        
        
        switch lesson.avail.color { //lesson.availability {
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
        
        for mark in lesson.marksNew {
            subViewX -= 22
            var point = CGPoint(x: subViewX, y: 11)
            var size = CGSize(width: 20, height: 22)
            var frame = CGRect(origin: point, size: size)
            var v = UIView(frame: frame)
            //v.tintColor = UIColor.greenColor()
            self.addSubview(v)

            switch mark.mark {
            case "4", "5" :
                v.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1) //.greenColor()
            case "3" :
                v.backgroundColor = UIColor(red: 249/255, green: 162/255, blue: 59/255, alpha: 1) //.orangeColor()
            case "2" :
                v.backgroundColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1) //.redColor()
            default :
                v.backgroundColor = UIColor(red: 194/255, green: 210/255, blue: 58/255, alpha: 1)
            }
            
            var label = UILabel()
            point = CGPoint(x: subViewX + 1, y: 12)
            size = CGSize(width: 18, height: 20)
            label.frame = CGRect(origin: point, size: size)
            label.font = UIFont.boldSystemFontOfSize(20)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Center
            label.text = mark.mark
            self.addSubview(label)
        }
        
    }

}
