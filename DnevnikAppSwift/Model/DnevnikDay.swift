//
//  DnevnikDay.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class DnevnikDay {
    let date : String //NSDate
    var lessons : [DnevnikLesson] = []
    
    init(date : String) {
        self.date = date
    }
}
