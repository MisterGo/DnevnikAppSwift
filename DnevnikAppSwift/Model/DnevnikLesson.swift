//
//  DnevnikLesson.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class DnevnikLesson {
    let subject : DnevnikSubject?
    let subjectName : String!  // в будущем вместо subjectName будет ссылка на DnevnikSubject
    var number : Int = 0
    var availability : String = ""
    var marks : [String] = []
    var homework : Bool = false
    var homeworkText : String = ""
    var homeworkState : String = ""
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