//
//  TeacherCell.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 13.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class TeacherCell : LessonTableViewCell {
    @IBOutlet var teacherPhoto : UIImageView!
    @IBOutlet var teacherName : UILabel!
    
    func configureFor(lesson : DnevnikLesson) {
        super.configureFor()
        
        let url = NSURL(string: lesson.teacherPhotoUrl)
        let data = NSData(contentsOfURL: url!)
        if data != nil {
            teacherPhoto.image = UIImage(data: data!)
        }
        
        teacherName.textColor = UIColor(red: 140/255, green: 175/255, blue: 49/255, alpha: 1)
        teacherName.font = UIFont.boldSystemFontOfSize(14)
        teacherName.text = lesson.teacher

    }
}
