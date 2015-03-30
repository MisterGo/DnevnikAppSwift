//
//  MarksViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 29.11.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

class MarksViewController : UITableViewController {

    @IBOutlet var sidebarButton : UIBarButtonItem!
    //@IBOutlet var headerCell : UIView!
    @IBOutlet var prevButton : UIBarButtonItem!
    @IBOutlet var thisButton : UIBarButtonItem!
    @IBOutlet var nextButton : UIBarButtonItem!
    
    var marksDays : [DnevnikDay] = []
    
    var loaded = false
    let regManager = RegManager()
    var prevURL = ""
    var nextURL = ""
    var thisURL = ""

    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView

    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    /*
    func parseString(str : String, patt : String, full : Bool = false) -> [String] {
        let regManager = RegexManager(patt)
        if full == false {
            return regManager.test(str) as [String]
        }
        return regManager.gefFull(str) as [String]
    }
    */
    func makeDate(rusStr : String) -> String { //NSDate {
        let monthDict : [String] =
            [
                "января",
                "февраля",
                "марта",
                "апреля",
                "мая",
                "июня",
                "июля",
                "августа",
                "сентября",
                "октября",
                "ноября",
                "декабря"
            ]
        var day = ""
        var month = ""
        var year = ""
        var weekDay = ""
        // дата с сайта выглядит так: Понедельник, 1&nbsp;декабря&nbsp;2014
        // сначала число
        day = self.regManager.getFirstMatch(rusStr, pattern: ",\\s(\\d+?)&nbsp")
        day = String(format: "%02d", day.toInt()!)
        //if countElements(day) == 1 {
        //    day = "0" + day
        //}
        // теперь месяц
        let monthRus = self.regManager.getFirstMatch(rusStr, pattern: "&nbsp;(.*?)&nbsp;")
        for i in 1...monthDict.count {
            if monthDict[i - 1] == monthRus {
                month = String(format: "%02d", i)
                break
            }
        }
        // ну и год
        year = self.regManager.getFirstMatch(rusStr, pattern: "&nbsp;(\\d{4})$")
        
        // день недели тоже лишним не будет
        weekDay = self.regManager.getFirstMatch(rusStr, pattern: "^(.*?),\\s")
        
        var dateString = weekDay + ", " + day + "." + month + "." + year  //"01-02-2010"
        return dateString
    }
    
    func parsePage() {
        let reqUrl = NSURL(string: Global.marksUrl)// + "?year=2014&month=11&day=22")
        //println("reqURL: \(reqUrl)")
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        var dnevnikDay : DnevnikDay?
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
            if data != nil {
                // Почистим массив дней
                self.marksDays = []
                
                let fullHTML = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                let headerText = self.regManager.getFirstMatch(fullHTML!, pattern: "Следующая неделя.*?<div class=\"inl\">\\s*?<h3>(.*?)</h3>\\s*?<ul class=\"filter\">")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: 44))
                    label.font = UIFont.boldSystemFontOfSize(12)
                    label.textColor = UIColor.darkGrayColor()
                    label.textAlignment = NSTextAlignment.Center
                    
                    label.text = headerText
                        .stringByReplacingOccurrencesOfString("&nbsp;", withString: " ", options: nil, range: nil)
                        .stringByReplacingOccurrencesOfString("&#151;", withString: "-", options: nil, range: nil)
                    self.navigationItem.titleView = label
                })
                
                let dayPatt = "<div\\sclass=\"panel blue2 clear\".*?<h3>(.*?)</h3>.*?</div></div></div>"
                let daysStrings = self.regManager.getStrings(fullHTML!, pattern: dayPatt)
                
                for dayBigStr in daysStrings {
                    let lessonPatt = "<tr>\\s*<td\\s*class=\"s2\".*?&lesson=\\d*?\">(.*?)</a>.*?</td></tr>"
                    let lessonsStrings = self.regManager.getStrings(dayBigStr, pattern: lessonPatt)
                    
                    if lessonsStrings.count > 0 {
                        //println("date: \(self.makeDate(dateStr)), lessons: \(lessonsArr)\n")
                    }

                    dnevnikDay = nil
                    var lessonsInDate = false
                    for lessonBigStr in lessonsStrings {
                        if lessonsInDate == false {
                            var dateStr = self.regManager.getFirstMatch(dayBigStr, pattern: "<h3>(.*?)</h3>")
                            dnevnikDay = DnevnikDay(date: self.makeDate(dateStr))
                            lessonsInDate = true
                        }
                        let lessonName = self.regManager.getFirstMatch(lessonBigStr, pattern: lessonPatt)
                        //println("date: \(dnevnikDay?.date), lesson: \(lessonName)")
                        
                        var lesson = DnevnikLesson(name: lessonName)
                        dnevnikDay!.lessons.append(lesson)
                        
                        // теперь поищем оценки за урок
                        let marksArr = self.regManager.getMatches(lessonBigStr, pattern: "class=\"mark\\s*m\\D\">(\\d.*?)</span>")
                        
                        for mStr in marksArr {
                            var mark = LessonMark(mark: mStr, comment: "")
                            lesson.marksNew.append(mark)
                        }
                        
                        // Домашнее задание
                        let homeWorkPatt = "<a\\s*href=\"http://\\D*?\\.dnevnik\\.ru/homework\\.aspx.*?<span class=\"breakword\">(.*?)</span>"
                        let homeWorkArr = self.regManager.getMatches(lessonBigStr, pattern: homeWorkPatt)
                        for hwStr in homeWorkArr {
                            //println("HW: \(hwStr)")
                            var hw = LessonHomework(state: "", text: hwStr)
                            lesson.homeworks.append(hw)
                        }
                        
                        // Посещаемость
                        let availPatt = "<td class=\"tac lpp ls(\\D)"
                        let availStr = self.regManager.getFirstMatch(lessonBigStr, pattern: availPatt)
                        lesson.avail.color = availStr
                        
                        // URL
                        let urlPatt = "href=\"(http://\\D*?\\.dnevnik\\.ru/lesson\\.aspx.*?)\">"
                        let urlStr = self.regManager.getFirstMatch(lessonBigStr, pattern: urlPatt)
                        lesson.url = urlStr
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        if (dnevnikDay != nil) {
                            self.marksDays.append(dnevnikDay!)
                        }
                    })
                    
                }
                
                // Prev week
                let prevPatt = "<div class=\"tabs\">.*?<div class=\"player\">.*?<li class=\"pB\">\\s*?<a href=\"(.*?)\" title=\"Предыдущая неделя\">"
                let prevURLTmp = self.regManager.getFirstMatch(fullHTML!, pattern: prevPatt)
                // Next week
                let nextPatt = "<li class=\"pF\">\\s*?<a href=\"(.*?)\" title=\"Следующая неделя\">"
                let nextURLTmp = self.regManager.getFirstMatch(fullHTML!, pattern: nextPatt)
                // This week
                let thisPatt = "Следующая неделя.*?<li class=\".*?first link\">\\s*?<a href=\"(.*?)\">Текущая неделя"
                let thisURLTmp = self.regManager.getFirstMatch(fullHTML!, pattern: thisPatt)
                //println("prevURL: \(prevURLTmp), encoded: \(NSString(CString: prevURLTmp, encoding: NSUTF8StringEncoding))")

                dispatch_async(dispatch_get_main_queue(), {
                    self.prevURL = prevURLTmp.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: nil, range: nil)
                    self.nextURL = nextURLTmp.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: nil, range: nil)
                    self.thisURL = thisURLTmp.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: nil, range: nil)
                    //self.marksDays.append(dnevnikDay!)
                    self.loaded = true
                    self.actInd.stopAnimating()
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    
                })
            
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Ой, всё!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButtonAction()
        // Установим footerView пустым, чтобы при загрузке не показывало пустые ячейки
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    func refresh(sender : AnyObject) {
        if marksDays.count == 0 {
            //self.marksDays = []
            actInd.center = self.tableView.center
            actInd.hidesWhenStopped = true
            actInd.hidden = false
            actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(actInd)
            actInd.startAnimating()
        }
        parsePage()
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        self.marksDays = []
        self.tableView.reloadData()
        self.refresh(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if marksDays.count == 0 {
            actInd.center = self.tableView.center
            actInd.hidesWhenStopped = true
            actInd.hidden = false
            actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(actInd)
            actInd.startAnimating()
            
            self.navigationController?.setToolbarHidden(false, animated: true)
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            let prevButton = UIBarButtonItem(title: "<Пред.", style: UIBarButtonItemStyle.Plain, target: self, action: "prevButtonPressed:")
            let nextButton = UIBarButtonItem(title: "След.>", style: UIBarButtonItemStyle.Plain, target: self, action: "nextButtonPressed:")
            let thisButton = UIBarButtonItem(title: "Текущая", style: UIBarButtonItemStyle.Plain, target: self, action: "thisButtonPressed:")
            
            self.toolbarItems = [prevButton, flexibleSpace, thisButton, flexibleSpace, nextButton]
            
            parsePage()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if loaded {
            return self.marksDays.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.marksDays[section].date
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sTitle = self.marksDays[section].date
        let rowsInSection : [DnevnikLesson] = self.marksDays[section].lessons
        return rowsInSection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "LessonCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as LessonCell
        
        let rowsInSection : [DnevnikLesson] = self.marksDays[indexPath.section].lessons
        let lesson = rowsInSection[indexPath.row]
        
        cell.configureFor(lesson)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Lesson Details Segue" {
            let lessonDetailsController = segue.destinationViewController as LessonTableController //LessonDetailsController
            let indexPath = self.tableView.indexPathForCell(sender as LessonCell)!
            let rowsInSection : [DnevnikLesson] = self.marksDays[indexPath.section].lessons
            let lesson = rowsInSection[indexPath.row]
            lessonDetailsController.lesson = lesson
        }
    }

    func prevButtonPressed(sender: AnyObject!) {
        Global.marksUrl = self.prevURL
        //println("prev: \(Global.marksUrl)")
        self.marksDays = []
        self.tableView.reloadData()
        self.refresh(self)
    }

    func nextButtonPressed(sender: AnyObject!) {
        Global.marksUrl = self.nextURL
        self.marksDays = []
        self.tableView.reloadData()
        self.refresh(self)
    }

    func thisButtonPressed(sender: AnyObject!) {
        Global.marksUrl = self.thisURL
        self.marksDays = []
        self.tableView.reloadData()
        self.refresh(self)
    }
}
