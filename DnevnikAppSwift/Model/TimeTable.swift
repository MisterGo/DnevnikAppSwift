//
//  TimeTable.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 18.01.15.
//  Copyright (c) 2015 Антон Гоголев. All rights reserved.
//

import Foundation

struct TTCell {
    var subject : String
    var teacher : String
    var timeBegin : NSDate? //String
    var timeEnd : NSDate? //String
    var room : String
}

class TTLesson {
    var number : Int
//    var cell : TTCell
    var subject : String?
    var teacher : String?
    var timeBegin : NSDate? //String
    var timeEnd : NSDate? //String
    var room : String?
    var current = false
    var progress : Float = 0.0

    init(number : Int) {
        self.number = number
//        self.cell = cell
    }
}

class TTDay {
    var date : NSDate
    var lessons : [TTLesson]!
    
    init(date: NSDate, lessons: [TTLesson]) {
        self.date = date
        self.lessons = lessons
    }
}

class TimeTable {
    var days : [TTDay]
    
    init(days: [TTDay]) {
        self.days = days
    }
}