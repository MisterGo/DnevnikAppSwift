//
//  RegexManager.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 04.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class RegManager {
    //var internalExpression: NSRegularExpression = NSRegularExpression()
    //var pattern: String = ""
    //var resultStr : [String] = []
    
    func match(input: String, pattern: String) -> [String] {
        var error : NSError?
        var resultStr : [String] = []
        //self.pattern = pattern
        var internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive | .DotMatchesLineSeparators, error: &error)!
        
        var matches : [String] = []
        var nsstr : NSString = NSString(string: input)
        internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input))) {
            (result : NSTextCheckingResult!, _, _) in
            resultStr.append(nsstr.substringWithRange(result.range))
            matches.append(nsstr.substringWithRange(result.rangeAtIndex(1)))
        }
        return matches
    }

    func getStrings(input: String, pattern: String) -> [String] {
        var error : NSError?
        var resultStr : [String] = []
        //self.pattern = pattern
        var internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive | .DotMatchesLineSeparators, error: &error)!
        
        var matches : [String] = []
        var nsstr : NSString = NSString(string: input)
        internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input))) {
            (result : NSTextCheckingResult!, _, _) in
            //            self.resultStr.append(nsstr.substringWithRange(result.range))
            matches.append(nsstr.substringWithRange(result.range))
            //println("...\n")
        }
        return matches
    }
    
    func getFirstString(input: String, pattern: String) -> String {
        let arr = self.getStrings(input, pattern: pattern)
        if arr.count > 0 {
            return arr[0]
        }
        return ""
    }

    func getMatches(input: String, pattern: String) -> [String] {
        let arr = self.match(input, pattern: pattern)
        if arr.count > 0 {
            return arr
        }
        return []
    }
    
    func getFirstMatch(input: String, pattern: String) -> String {
        let arr = self.match(input, pattern: pattern)
        if arr.count > 0 {
            return arr[0]
        }
        return ""
    }
    
}

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
        self.internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input))) {
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
        self.internalExpression.enumerateMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input))) {
            (result : NSTextCheckingResult!, _, _) in
//            self.resultStr.append(nsstr.substringWithRange(result.range))
            matches.append(nsstr.substringWithRange(result.range))
            //println("...\n")
        }
        return matches
    }
    
    func getFirstMatch(input: String) -> String {
        let arr = self.test(input)
        if arr.count > 0 {
            return arr[0]
        }
        return ""
    }
    
    func getAllMatches(input: String) -> [String] {
        let arr = self.test(input)
        if arr.count > 0 {
            return arr
        }
        return [""]
    }
}
