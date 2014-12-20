//
//  HTTPHelper.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 30.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import Foundation

class HTTPHelper {
    var _urlString : String
    var _manager : AFHTTPSessionManager
    var _completed : Bool
    var _params : [String : String]?
    
    var _httpResponse : NSHTTPURLResponse?
    var _fullHtml : NSString?
    
    init(urlString : String) {
        self._urlString = urlString
        self._completed = false
        self._manager = AFHTTPSessionManager()
        self._manager.responseSerializer = AFHTTPResponseSerializer()
        self._manager.requestSerializer = AFHTTPRequestSerializer()
    }
    
    func get() {
        self._manager.GET(
            self._urlString,
            parameters: self._params,
            success:
            { (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self._httpResponse = task.response as? NSHTTPURLResponse
                if self._httpResponse?.statusCode == 200 {
                    self._fullHtml = NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding)
                    
                    //let patt = "\\s*name=\"(xss)\"\\s*value=\"(.*?)\".*?/>"
                    //let xss = patt.exec(bigStr!)
                    //if (xss.count > 0) {
                    //    self.ss = xss[0]
                    //    println("\(xss[0])\n")
                    //}
                    
                } else {
                    println("GET Error -> Code: \(self._httpResponse?.statusCode), Msg: \(responseObject)")
                }
            }
            ,
            failure:
            { (task: NSURLSessionDataTask!, error: NSError!) in
                println("GET Networking Error", message: "GET Error -> \(self._urlString) -> \(error)")
            }
        )
    }
    
    func head() {
        self._manager.HEAD(
            self._urlString,
            parameters: self._params,
            success:
            { (task: NSURLSessionDataTask!) in
                self._httpResponse = task.response as? NSHTTPURLResponse
                Global.completed = true
                println("HEAD RESPONSE = \(self._httpResponse?.description)")
            }
            ,
            failure:
            { (task: NSURLSessionDataTask!, error: NSError!) in
                println("HEAD Networking Error", message: "GET Error -> \(self._urlString) -> \(error)")
            }
        )
    }
    
    func post() {
        self._manager.POST(
            self._urlString,
            parameters: self._params,
            success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self._httpResponse = task.response as NSHTTPURLResponse?
                if self._httpResponse?.statusCode == 200 {
                    //println("POST OK -> \(httpResponse.description)\n")
                    //println("------------\n")
                    self._fullHtml = NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding)
                    //                    println("OBJECT: \(bigStr)\n")
                } else {
                    println("POST Error -> Code: \(self._httpResponse?.statusCode), Msg: \(responseObject)")
                }
                
            }
            ,
            failure:
            { (task: NSURLSessionDataTask!, error: NSError!) in
                println("POST Networking Error", message: "GET Error -> \(self._urlString) -> \(error)")
            }
        )
    }
}
