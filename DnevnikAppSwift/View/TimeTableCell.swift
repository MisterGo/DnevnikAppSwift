//
//  TimeTableCell.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 31.01.15.
//  Copyright (c) 2015 Anton Gogolev. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {
//    var numberLabelOld : UILabel = UILabel()
//    @IBOutlet weak var numberLabel : UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var indicator: UIProgressView!
    
    func configureFor(ttLesson : TTLesson) {
        
        indicator.hidden = !ttLesson.current
        if ttLesson.current {
            indicator.progress = ttLesson.progress
        }
        
        cellView.layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).CGColor
        cellView.layer.borderWidth = 1
        
        numberLabel.text = "\(ttLesson.number)"
        
        subjectLabel.text = ttLesson.subject
        teacherLabel.text = ttLesson.teacher
//        timeLabel.text = "\(ttLesson.cell.timeBegin!) - \(ttLesson.cell.timeEnd!)"
        roomLabel.text = ttLesson.room
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "HH:mm"
        if (ttLesson.timeBegin != nil) && (ttLesson.timeEnd != nil) {
            timeLabel.text = "\(dateFormatter.stringFromDate(ttLesson.timeBegin!)) - \(dateFormatter.stringFromDate(ttLesson.timeEnd!))"
        } else {
            timeLabel.text = "Время не указано"
        }
    }
}