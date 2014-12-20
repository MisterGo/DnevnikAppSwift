//
//  RegexManager.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class RegexManager {
    let internalExpression: NSRegularExpression
    let pattern: String
    var resultStr : [String] = []
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive | .DotMatchesLineSeparators, error: &error)!
    }
    
    func test(input: String) -> [String] {
        //let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
        var matches : [String] = []
        var nsstr : NSString = NSString(string: input)
        self.internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, countElements(input))) {
            (result : NSTextCheckingResult!, _, _) in
                self.resultStr.append(nsstr.substringWithRange(result.range))
                matches.append(nsstr.substringWithRange(result.rangeAtIndex(1)))
                //println("...\n")
            }
        return matches
    }

    func gefFull(input: String) -> [String] {
        //let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
        var matches : [String] = []
        var nsstr : NSString = NSString(string: input)
        self.internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, countElements(input))) {
            (result : NSTextCheckingResult!, _, _) in
//            self.resultStr.append(nsstr.substringWithRange(result.range))
            matches.append(nsstr.substringWithRange(result.range))
            //println("...\n")
        }
        return matches
    }
}
