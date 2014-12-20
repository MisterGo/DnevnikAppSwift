//
//  LessonDetailsController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 09.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class LessonDetailsController : UIViewController {
    @IBOutlet var subjectView : UIView!
    @IBOutlet var roomLabel : UILabel!
    @IBOutlet var themeLabel : UILabel!
    @IBOutlet var homeWorkView : UIView!
    @IBOutlet var homeWorkLabel : UILabel!
    
    var lesson : DnevnikLesson?
    
    func parseString(str : String, patt : String, full : Bool = false) -> [String] {
        let regManager = RegexManager(patt)
        if full == false {
            return regManager.test(str) as [String]
        }
        return regManager.gefFull(str) as [String]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.lesson?.subjectName
        self.subjectView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.subjectView.layer.borderWidth = 0.5
        self.subjectView.layer.cornerRadius = 5
        self.subjectView.backgroundColor = UIColor(red: 219/255, green: 226/255, blue: 230/255, alpha: 0.6)
        //self.subjectView.layer.opacity = 0.6
        self.homeWorkView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.homeWorkView.layer.borderWidth = 0.5
        self.homeWorkView.layer.cornerRadius = 5
        self.homeWorkView.backgroundColor = UIColor(red: 219/255, green: 226/255, blue: 230/255, alpha: 0.6)
        self.roomLabel.text = ""
        self.themeLabel.text = ""
        self.homeWorkLabel.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        parsePageAsync()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parsePageAsync() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        //actInd.backgroundColor = UIColor(red: 0, green: 0, blue: 100/255, alpha: 0.3)
        actInd.center = self.subjectView.center
        actInd.hidesWhenStopped = true
        actInd.hidden = false
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.subjectView.addSubview(actInd)
        //self.subjectView.bringSubviewToFront(actInd)
        actInd.startAnimating()
        //println("IND: \(actInd.frame.size), desc: \(actInd.description)")
        
        let reqUrl = NSURL(string: self.lesson!.url)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue)
            {response,data,error in
                if data != nil {
                    //println("data <> nil : \(NSDate())")
                    //sleep(1)
                    let fullStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //println("fullStr ready: \(NSDate())")
                    //sleep(1)
                    let roomPatt = "<dt>\\s*?Кабинет:\\s*?</dt>\\s*?<dd>\\s*(.*?)\\s*?</dd>"
                    var roomArr = self.parseString(fullStr!, patt: roomPatt)
                    if roomArr.count > 0 {
                        self.lesson?.room = roomArr[0]
                        //dispatch_async(dispatch_get_main_queue(), {
                        //    self.roomLabel.text = roomArr[0]
                        //})
                    }
                    //println("roomLabel ready: \(NSDate())")
                    //sleep(1)

                    let themePatt = "<dt>\\s*?Тема\\s*?урока:\\s*?</dt>\\s*?<dd>\\s*?(.*?)\\s*?</dd>"
                    var themeArr = self.parseString(fullStr!, patt: themePatt)
                    if themeArr.count > 0 {
                        var str = themeArr[0].stringByReplacingOccurrencesOfString("&amp;#171;", withString: "\"", options: nil, range: nil)
                        str = str.stringByReplacingOccurrencesOfString("&amp;#187;", withString: "\"", options: nil, range: nil)
                        
                        self.lesson?.theme = str
                        //dispatch_async(dispatch_get_main_queue(), {
                        //    self.themeLabel.text = str
                        //})
                    }
                    //println("themeLabel ready: \(NSDate())")
                    //sleep(1)
                    
                    let homeWorkPatt = "</strong>\\s*?</td>\\s*?<td>(.*?)</td>"
                    var homeWorkArr = self.parseString(fullStr!, patt: homeWorkPatt)
                    if homeWorkArr.count > 0 {
                        self.lesson?.homeworkText = homeWorkArr[0]
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.fillInfo(self.lesson!)
                        actInd.stopAnimating()
                    })
                    //println("HWLabel ready: \(NSDate())")
                    
                }
            }
    }
    
    func fillInfo(lesson : DnevnikLesson) {
        self.roomLabel.text = lesson.room
        self.themeLabel.text = lesson.theme
        self.homeWorkLabel.text = lesson.homeworkText
    }
    
    func parsePage() {

        let reqUrl = NSURL(string: self.lesson!.url)
        let request = NSURLRequest(URL:reqUrl!)
        var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error : NSErrorPointer = nil
        var data : NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)!
        
        let fullStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        let roomPatt = "<dt>\\s*?Кабинет:\\s*?</dt>\\s*?<dd>\\s*(.*?)\\s*?</dd>"
        var roomArr = self.parseString(fullStr!, patt: roomPatt)
        if roomArr.count > 0 {
            self.roomLabel.text = roomArr[0]
        }
        
        let themePatt = "<dt>\\s*?Тема\\s*?урока:\\s*?</dt>\\s*?<dd>\\s*?(.*?)\\s*?</dd>"
        var themeArr = self.parseString(fullStr!, patt: themePatt)
        if themeArr.count > 0 {
            var str = themeArr[0].stringByReplacingOccurrencesOfString("&amp;#171;", withString: "\"", options: nil, range: nil)
            str = str.stringByReplacingOccurrencesOfString("&amp;#187;", withString: "\"", options: nil, range: nil)
            self.themeLabel.text = str
        }
        
        let homeWorkPatt = "</strong>\\s*?</td>\\s*?<td>(.*?)</td>"
        var homeWorkArr = self.parseString(fullStr!, patt: homeWorkPatt)
        if homeWorkArr.count > 0 {
            self.homeWorkLabel.text = homeWorkArr[0]
        }

    }
    
}
