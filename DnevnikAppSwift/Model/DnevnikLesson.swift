//
//  DnevnikLesson.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

struct LessonMark {
    var mark : String
    var comment : String
}
struct LessonHomework {
    var state : String
    var text : String
}
struct LessonAvailability {
    var color : String
    var state : String
    var comment : String
}

class DnevnikLesson {
    
    let subject : DnevnikSubject?
    let subjectName : String!  // в будущем вместо subjectName будет ссылка на DnevnikSubject
    var number : Int = 0
    var availability : String = "" // color
    var availState : String = ""
    var availComment : String = ""
    var avail = LessonAvailability(color: "", state: "", comment: "")
    var marks : [String] = []
    var marksComments : [String] = []
    var marksNew : [LessonMark] = []
    var homework : Bool = false
    var homeworkText : String = ""
    var homeworkState : String = ""
    var homeworks : [LessonHomework] = []
    var url : String = ""
    var teacher : String = ""
    var teacherPhotoUrl : String = ""
    var details : [String : String] = [:]
    var theme : String = ""
    var room : String = ""
    
    init(name : String) {
        self.subjectName = name
    }
}