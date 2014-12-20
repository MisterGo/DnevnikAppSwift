//
//  DnevnikSubject.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class DnevnikSubject {
    var name : String!
    
    init(name : String) {
        self.name = name
    }
    
    func getName() -> String {
        return self.name
    }
}