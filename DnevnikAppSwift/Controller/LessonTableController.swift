//
//  LessonDetailsTableController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 14.12.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class LessonTableController : UITableViewController {
    
    var lesson : DnevnikLesson?
    var loaded = false
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    let lessonSections = ["Учитель", "Детали", "Присутствие на уроке", "Домашние задания", "Оценки"]
    
    func parseString(str : String, patt : String, full : Bool = false) -> [String] {
        let regManager = RegexManager(patt)
        if full == false {
            return regManager.test(str) as [String]
        }
        return regManager.gefFull(str) as [String]
    }

    func parsePage() {
        let reqUrl = NSURL(string: self.lesson!.url)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
            if data != nil {
                //println("data <> nil : \(NSDate())")
                //sleep(1)
                var tmpLesson = self.lesson
                
                let fullStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                let photoPatt = "<h3>\\s*?Учитель\\s*?</h3>.*?img src=\"(.*?)\""
                let photoArr = self.parseString(fullStr!, patt: photoPatt)
                if photoArr.count > 0 {
                    tmpLesson?.teacherPhotoUrl = photoArr[0].stringByReplacingOccurrencesOfString(".s.", withString: ".l.", options: nil, range: nil)
                }

                let teacherPatt = "<a\\s*?href=.*?class=\"u\">(.*?)</a>"
                let teacherArr = self.parseString(fullStr!, patt: teacherPatt)
                if teacherArr.count > 0 {
                    tmpLesson?.teacher = teacherArr[0]
                }
                
                var detailsBlock : [String : String] = [:]
                
                let detailsBlockPatt = "<dl\\s*?class=\"info\">.*?</dl>"
                let detailsBlockStr = self.parseString(fullStr!, patt: detailsBlockPatt, full: true)[0]
                
                let detailsIndexPatt = "<dt>(.*?)</dt>"
                let detailsIndexArr = self.parseString(detailsBlockStr, patt: detailsIndexPatt)
                if detailsIndexArr.count > 0 {
                    for ind in detailsIndexArr {
                        detailsBlock.updateValue("", forKey: ind)
                    }
                }
                
                for key in detailsBlock.keys {
                    var str = ""
                    let ddPatt = key + ".*?<dd>\\s*?(\\S.*?)\\s*?</dd>"
                    let ddArr = self.parseString(detailsBlockStr, patt: ddPatt)
                    if ddArr.count > 0 {
                        str = ddArr[0]
                        let strongPatt = "<strong.*?>\\s*?(.*?)\\s*?</strong>"
                        let strongArr = self.parseString(str, patt: strongPatt)
                        if strongArr.count > 0 {
                            str = strongArr[0]
                            let aPatt = "<a\\s*?href=.*?>\\s*?(.*?)\\s*?</a>"
                            let aArr = self.parseString(str, patt: aPatt)
                            if aArr.count > 0 {
                                str = aArr[0]
                            }
                        }
                    }
                    str = str.stringByReplacingOccurrencesOfString("&nbsp;", withString: " ", options: nil, range: nil)
                    str = str.stringByReplacingOccurrencesOfString("&amp;#171;", withString: "\"", options: nil, range: nil)
                    str = str.stringByReplacingOccurrencesOfString("&amp;#187;", withString: "\"", options: nil, range: nil)

                    detailsBlock.updateValue(str, forKey: key)
                }
                tmpLesson?.details = detailsBlock
                //println("indexArr : \(detailsBlock)")
                //println("block: \(detailsBlockStr)")
                
                let availPatt = "Присутствие на уроке.*?</h3>.*?<td class=\"tac ls\\D\".*?>(.*?)</td>"
                let availArr = self.parseString(fullStr!, patt: availPatt)
                if availArr.count > 0 {
                    tmpLesson?.availState = availArr[0]
                }
                let availCommPatt = "Присутствие на уроке.*?</h3>.*?<td class=\"tac\".*?>(.*?)</td>"
                let availCommArr = self.parseString(fullStr!, patt: availCommPatt)
                if availCommArr.count > 0 {
                    tmpLesson?.availComment = availCommArr[0]
                }
                //println("Avail: \(tmpLesson?.availability), \(tmpLesson?.availComment)")

                let homeWorkPatt = "Домашние задания.*?</h3>.*?</strong>.*?</td>.*?<td>(.*?)</td>.*?Оценки"
                var homeWorkArr = self.parseString(fullStr!, patt: homeWorkPatt)
                if homeWorkArr.count > 0 {
                    tmpLesson?.homeworkText = homeWorkArr[0]
                }
                let hwStatePatt = "Домашние задания.*?</h3>.*?</strong>.*?</td>.*?<td\\s*?class=\"tac nowrap.*?>(.*?)</td>.*?Оценки"
                var hwStateArr = self.parseString(fullStr!, patt: hwStatePatt)
                if hwStateArr.count > 0 {
                    tmpLesson?.homeworkState = hwStateArr[0]
                }
                
                let marksBlockPatt = "Оценки за работу на уроке</h3>(.*?</div>\\s*?</div>\\s*?</div>\\s*?</div>\\s*?</div>)"
                let marksBlockStr = self.parseString(fullStr!, patt: marksBlockPatt, full: true)[0]
                //println("BLOCK: \(marksBlockStr)")
                
                let marksPatt = "class=\"mark\\s*m\\D\">(\\d)</span>"
                let marksArr = self.parseString(marksBlockStr, patt: marksPatt)
                if marksArr.count > 0 {
                    for i in 0...marksArr.count - 1 {
                        //tmpLesson?.marks.append(marksArr[i])
                        //tmpLesson?.marksComments.append("-")
                    }
                }
                //println("count: \(marksArr.count)")
                //println("marks: \(tmpLesson?.marks), comm: \(tmpLesson?.marksComments)")

                let marksCommPatt = "<div class=\"light\">(.*?)</div>"
                let marksCommArr = self.parseString(marksBlockStr, patt: marksCommPatt)
                if marksCommArr.count > 0 {
                    for i in 0...marksCommArr.count - 1 {
                        //tmpLesson?.marksComments[i] = marksCommArr[i]
                        tmpLesson?.marksComments.append(marksCommArr[i])
                    }
                }
                // специально для нашей англичанки
                let marksCommPatt2 = "<div class=\"light\">.*?</div>(.*?)</td>"
                let marksCommArr2 = self.parseString(marksBlockStr, patt: marksCommPatt2)
                if marksCommArr2.count > 0 {
                    for i in 0...marksCommArr2.count - 1 {
                        //tmpLesson?.marksComments[i] = marksCommArr2[i]
                        tmpLesson?.marksComments.append(marksCommArr2[i])
                    }
                }
                //println("marks2: \(tmpLesson?.marks), comm2: \(tmpLesson?.marksComments)")

                dispatch_async(dispatch_get_main_queue(), {
                    self.lesson = tmpLesson
                })
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.loaded = true
                self.actInd.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                })
        }
    }

    func refresh(sender : AnyObject) {
        parsePage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установим footerView пустым, чтобы при загрузке не показывало пустые ячейки
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.hidden = false
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(actInd)
        //self.subjectView.bringSubviewToFront(actInd)
        actInd.startAnimating()
        parsePage()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if loaded {
            return self.lessonSections.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case find(lessonSections, "Учитель")! :
            return 80
        case find(lessonSections, "Детали")! :
            return 30
//        case find(lessonSections, "Домашние задания")! :
//            return 38
        default :
            return 38
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.lessonSections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case find(lessonSections, "Детали")! :
            let details = self.lesson?.details
            let arr = details?.keys.array as [String]!
            return arr.count
        case find(lessonSections, "Оценки")! :
            let arr = self.lesson?.marks as [String]!
            return arr.count
        default :
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case find(lessonSections, "Учитель")! :
            var cellIdentifier = "TeacherCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            let newCell = cell as TeacherCell
            newCell.configureFor(lesson!)
            //return cell as TeacherCell
            return newCell
        case find(lessonSections, "Детали")! :
            var cellIdentifier = "LessonDetailCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            
            let details = self.lesson?.details
            let keys = details?.keys.array as [String]!
            let values = details?.values.array as [String]!
            let key = keys[indexPath.row]
            
            var newCell = cell as LessonDetailCell
            newCell.configureFor(keys[indexPath.row], value: values[indexPath.row])
            return newCell
        case find(lessonSections, "Домашние задания")! :
            var cellIdentifier = "OtherDetail"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            
            var newCell = cell as OtherDetailCell
            newCell.configureFor(lesson!, key: lesson!.homeworkState, val: lesson!.homeworkText, type: .homeWorkType)
            return newCell
        case find(lessonSections, "Оценки")! :
            var cellIdentifier = "OtherDetail"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            
            let mark = self.lesson?.marks[indexPath.row]
            let markComm = self.lesson?.marksComments[indexPath.row]
            
            var newCell = cell as OtherDetailCell
            newCell.configureFor(lesson!, key: mark!, val: markComm!, type: .marksType)
            return newCell
        case find(lessonSections, "Присутствие на уроке")! :
            var cellIdentifier = "OtherDetail"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            
            let avail = self.lesson?.availState
            let availComm = self.lesson?.availComment
            
            var newCell = cell as OtherDetailCell
            newCell.configureFor(lesson!, key: avail!, val: availComm!, type: .availType)
            return newCell
            
            
        default :
            var cellIdentifier = "OtherDetail"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonTableViewCell
            var newCell = cell as OtherDetailCell
            newCell.configureFor(lesson!, key: "--", val: "---", type: .availType)
            return newCell
        }
        
    }

}