//
//  Global.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

struct Global {
    static var isLogoned = false
    static let RESPONSE_OK = 200
    static let loginUrl = "https://login.dnevnik.ru"
    static let dnevnikUrl = "https://dnevnik.ru"
    static var marksUrl = "http://children.dnevnik.ru/marks.aspx"
    static var timetableUrl = "http://children.dnevnik.ru/timetable.aspx"
    static var completed = false
}