//
//  TimeTableViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class TimeTableViewController : UITableViewController {
    
    @IBOutlet weak var sidebarButton : UIBarButtonItem!
    
    var currentSection : Int?
    let regManager = RegManager()
    var timeTable = TimeTable(days: [])

    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView

    @IBAction func refreshButtonPressed(sender: AnyObject) {
        self.timeTable.days = []
        self.tableView.reloadData()
        self.refresh(self)
    }
    
    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    func parsePage() {
        let reqUrl = NSURL(string: Global.timetableUrl)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        self.timeTable.days = []
        
        var ttDict : [String : TTDay] = [:]
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
            if data != nil {
                let fullHTML = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                var headerText = self.regManager.getFirstMatch(fullHTML, pattern: "Следующая неделя.*?<div class=\"light filter\">\\s*?<strong class=.*?>(.*?)</strong>.*?всего")
                
                headerText = headerText
                    .stringByReplacingOccurrencesOfString("&nbsp;", withString: " ", options: nil, range: nil)
                    .stringByReplacingOccurrencesOfString("&#151;", withString: "-", options: nil, range: nil)

                //println("header: \(headerText)")
                
                var currentDateStr = ""
                
                let tHeaderPatt = "<th class=\"wD.*?\">.*?href=\"(.*?calendar.aspx.*?)\">"
                let tHeaderStrings = self.regManager.getMatches(fullHTML, pattern: tHeaderPatt)
                for tHeaderStr in tHeaderStrings {
                    let year = self.regManager.getFirstMatch(tHeaderStr, pattern: "year=(\\d{4})&")
                    let month = self.regManager.getFirstMatch(tHeaderStr, pattern: "&month=(\\d{1,2})&")
                    let day = self.regManager.getFirstMatch(tHeaderStr, pattern: "&day=(\\d{1,2})$")
                    let dateStr = year + String(format: "%02d", month.toInt()!) + String(format: "%02d", day.toInt()!)
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let date = dateFormatter.dateFromString(dateStr)
                    println("year = \(year), month = \(month), day = \(day), str = \(dateStr), date: \(date?.descriptionWithLocale(NSLocale.systemLocale()))")
                    currentDateStr = dateFormatter.stringFromDate(NSDate())

                    ttDict[dateStr] = TTDay(date: date!, lessons: [])
                }
                self.currentSection = find(ttDict.keys.array.sorted({$0 < $1}), currentDateStr)!
                if self.currentSection == nil {
                    self.currentSection = 0
                }
                println("index of today: \(self.currentSection!)")
                
                //println("\nttDict: \(ttDict.keys.array.sorted({$0 < $1}))")
                
                let ttLessonPatt = "<td id=\"d(\\d{8}_\\d{1,2})\" class=\"wD d\\d{8}\\s*?\">.*?</td>"
                let ttLessonStrings = self.regManager.getStrings(fullHTML, pattern: ttLessonPatt)
                for ttLessonStr in ttLessonStrings {
                    let match = self.regManager.getFirstMatch(ttLessonStr, pattern: ttLessonPatt)
                    let dateStr = match.substringToIndex(advance(match.startIndex, 8))
                    let numStr = match.substringFromIndex(advance(match.startIndex, 9))
                    
                    //println("match: \(match), dateStr: \(dateStr), numStr: \(numStr)")
                    
                    let ttLesson = TTLesson(number: numStr.toInt()!)
                    ttDict[dateStr]?.lessons.append(ttLesson)
                    
                    let ttCellPatt = "<div.*?</div>"
                    let ttCellStrings = self.regManager.getStrings(ttLessonStr, pattern: ttCellPatt)
                    for ttCellStr in ttCellStrings {
                        let lessonName = self.regManager.getFirstMatch(ttCellStr, pattern: "<a.*?title=\"(.*?)\">.*?</a>")
                        let teacherName = self.regManager.getFirstMatch(ttCellStr, pattern: "<p title=\"Учитель: (.*?)\">.*?</p>")
                        let place = self.regManager.getFirstMatch(ttCellStr, pattern: "<p title=\"Место проведения: (.*?)\">.*?</p>")
                        let timeStr = self.regManager.getFirstMatch(ttCellStr, pattern: "<p title=\"Время.*?\">(.*?)</p>")
                        let lessonUrl = self.regManager.getFirstMatch(ttCellStr, pattern: "<a href=\"(.*?)\".*?title=\".*?\">.*?</a>")
                        
                        var req = NSURLRequest(URL: NSURL(string: lessonUrl)!)
                        var resp: NSURLResponse?
                        var dd = NSURLConnection.sendSynchronousRequest(req, returningResponse: &resp, error: nil)
                        if let httpResponse = resp as? NSHTTPURLResponse {
                            if httpResponse.statusCode == 403 {
                                println("lesson: \(lessonName), status: \(httpResponse.statusCode)")
                                continue
                            }
                        }
                        
                        ttLesson.subject = lessonName
                        ttLesson.teacher = teacherName
                        ttLesson.room = place
                        
//                        println("timeStr: \(timeStr)")
                        
                        let begStr : String? = self.regManager.getFirstMatch(timeStr, pattern: "^(\\d{1,2}:\\d{2})")
                        let endStr : String? = self.regManager.getFirstMatch(timeStr, pattern: "\\s(\\d{1,2}:\\d{2})$")
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyyMMdd HH:mm"
                        let timeBegin = dateFormatter.dateFromString(dateStr + " " + begStr!)
                        let timeEnd = dateFormatter.dateFromString(dateStr + " " + endStr!)
//                        println(" timeBegin: \(timeBegin), timeEnd: \(timeEnd)")
                        
                        if (timeBegin != nil) && (timeEnd != nil) {
                            ttLesson.timeBegin = timeBegin
                            ttLesson.timeEnd = timeEnd

                            let diff = ttLesson.timeEnd!.timeIntervalSinceDate(ttLesson.timeBegin!)
                            //println("diff: \(diff)")
                            
                            let int1 = ttLesson.timeBegin?.timeIntervalSinceNow
                            let int2 = ttLesson.timeEnd?.timeIntervalSinceNow
                            
                            if int1 < 0 && int2 > 0 {
                                ttLesson.current = true
                                ttLesson.progress = -Float(int1!) / Float(diff)
                                println("progress: \(ttLesson.progress) , int1 = \(int1), diff = \(diff)")
                                
                            }
                        }
                        
                        //println("timeStr: \(timeStr), timebegin: \(timeBegin), timeend: \(timeEnd)")
                        
                        //println("lesson: \(lessonName), teacher: \(teacherName), time: \(timeStr), place: \(place)")
                        //println("struct: \(ttCell), beg: \(ttCell.timeBegin.descriptionWithLocale(NSLocale.systemLocale()))\n")
                    }
                    // На случай, если все группы урока - чужие
                    if ttLesson.subject == nil {
                        ttDict[dateStr]?.lessons.removeLast()
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    for dateStr in ttDict.keys.array.sorted({$0 < $1}) {
                        
                        if ttDict[dateStr]?.lessons.count > 0 {
//                            println("dateStr: \(dateStr), count: \(ttDict[dateStr]?.lessons.count)")
                            let day : TTDay = ttDict[dateStr]!
                            self.timeTable.days.append(day)
                        }
                    }
                    self.actInd.stopAnimating()
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    self.scrollToCurrentLesson()
 
                })
                
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Ой, всё!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            
        }
        
    }
    
    func scrollToCurrentLesson() {
        println("currentSection: \(self.currentSection)")
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.currentSection!), atScrollPosition: .Top, animated: true)
    }

    func refresh(sender : AnyObject) {
        if timeTable.days.count == 0 {
            actInd.center = self.tableView.center
            actInd.hidesWhenStopped = true
            actInd.hidden = false
            actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(actInd)
            actInd.startAnimating()
        }
        parsePage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButtonAction()
        
        self.tableView.tableFooterView = UIView()

        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if timeTable.days.count == 0 {
            actInd.center = self.tableView.center
            actInd.hidesWhenStopped = true
            actInd.hidden = false
            actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(actInd)
            actInd.startAnimating()
        }
        parsePage()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeTable.days.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable.days[section].lessons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "TimeTableCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TimeTableCell
        
        let rowsInSection : [TTLesson] = self.timeTable.days[indexPath.section].lessons
        let ttLesson = rowsInSection[indexPath.row] as TTLesson
        
//        if (ttLesson.timeBegin != nil) && (ttLesson.timeEnd != nil) {
//            let diff = ttLesson.timeEnd!.timeIntervalSinceDate(ttLesson.timeBegin!)
//            //println("diff: \(diff)")
//        
//            let int1 = ttLesson.timeBegin?.timeIntervalSinceNow
//            let int2 = ttLesson.timeEnd?.timeIntervalSinceNow
//        
//            if int1 < 0 && int2 > 0 {
//                ttLesson.current = true
//                ttLesson.progress = -Float(int1!) / Float(diff)
//                println("progress: \(ttLesson.progress) , int1 = \(int1), diff = \(diff)")
//            
//            }
//        }
        cell.configureFor(ttLesson)
        
//        if ttLesson.current {
//            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
//        }
        return cell

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, dd.MM.yyyy"
        formatter.locale = NSLocale.currentLocale()
        let date = timeTable.days[section].date
        return formatter.stringFromDate(date).capitalizedString
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
