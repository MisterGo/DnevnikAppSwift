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
    
    var marksDays : [DnevnikDay] = []

    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func parseString(str : String, patt : String, full : Bool = false) -> [String] {
        let regManager = RegexManager(patt)
        if full == false {
            return regManager.test(str) as [String]
        }
        return regManager.gefFull(str) as [String]
    }
    
    func makeDate(rusStr : String) -> String { //NSDate {
        var patt : String
        var regManager : RegexManager
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
        //patt = ",\\s(\\d+?)&nbsp"
        //regManager = RegexManager(patt)
        
        day = parseString(rusStr, patt: ",\\s(\\d+?)&nbsp")[0] as String
        //day = regManager.test(rusStr)[0] as String
        if countElements(day) == 1 {
            day = "0" + day
        }
        // теперь месяц
        //patt = "&nbsp;(.*?)&nbsp;"
        //regManager = RegexManager(patt)
        //let monthRus = regManager.test(rusStr)[0] as String
        let monthRus = parseString(rusStr, patt: "&nbsp;(.*?)&nbsp;")[0] as String
        for i in 1...monthDict.count {
            if monthDict[i - 1] == monthRus {
                month = String(format: "%02d", i)
                break
            }
        }
        // ну и год
        //patt = "&nbsp;(\\d{4})$"
        //regManager = RegexManager(patt)
        //year = regManager.test(rusStr)[0] as String
        year = parseString(rusStr, patt: "&nbsp;(\\d{4})$")[0] as String
        
        // день недели тоже лишним не будет
        weekDay = parseString(rusStr, patt: "^(.*?),\\s")[0] as String
        
        var dateString = weekDay + ", " + day + "." + month + "." + year  //"01-02-2010"
        return dateString
        
        //var dateFormatter = NSDateFormatter()
        // this is imporant - we set our input date format to match our input string
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 6 * 3600)
        // voila!
        //var dateFromString = dateFormatter.dateFromString(dateString)
        //return dateFromString!
    }
    
    func parsePage() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        actInd.center = self.tableView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        let reqUrl = NSURL(string: Global.marksUrl)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        var dnevnikDay : DnevnikDay?
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
            if data != nil {
                let fullStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let dayPatt = "<div\\sclass=\"panel blue2 clear\".*?<h3>(.*?)</h3>.*?</div></div></div>"
                
                var regArr = self.parseString(fullStr!, patt: dayPatt)
                if regArr.count > 0 {
                    for i in 0...regArr.count - 1 {
                        
                        let dayBigStr = self.parseString(fullStr!, patt: dayPatt, full: true)[i]
                        //regManager.resultStr[i] as String
                        let lessonPatt = "<tr>\\s*<td\\s*class=\"s2\".*?&lesson=\\d*?\">(.*?)</a>.*?</td></tr>"
                        let lessonsArr = self.parseString(dayBigStr, patt: lessonPatt)
                        
                        if lessonsArr.count > 0 {
                            // добавим день с уроками в массив
                            let dateStr = self.makeDate(regArr[i])
                            dnevnikDay = DnevnikDay(date: dateStr)
                            
                            //println("DATE: : \(regArr[i]), \(dateStr)")
                            //println("lessons count: \(lessonsArr.count)")
                            for i in 0...lessonsArr.count - 1 {
                                // добавим урок в дату
                                var lesson = DnevnikLesson(name: lessonsArr[i])
                                dnevnikDay!.lessons.append(lesson)
                                
                                // теперь поищем оценки за урок
                                let lessonBigStr = self.parseString(dayBigStr, patt: lessonPatt, full: true)[i]
                                let marksPatt = "class=\"mark\\s*m\\D\">(\\d)</span>"
                                let marksArr = self.parseString(lessonBigStr, patt: marksPatt)
                                if marksArr.count > 0 {
                                    for i in 0...marksArr.count - 1 {
                                        lesson.marks.append(marksArr[i])
                                        //lesson.marks.
                                    }
                                }
                                
                                // Домашнее задание
                                let homeWorkPatt = "<a\\s*href=\"http://children.dnevnik.ru/homework.aspx"
                                let homeWorkArr = self.parseString(lessonBigStr, patt: homeWorkPatt, full: true)
                                if homeWorkArr.count > 0 {
                                    lesson.homework = true
                                }
                                
                                // Посещаемость
                                let availPatt = "<td class=\"tac lpp ls(\\D)"
                                let availArr = self.parseString(lessonBigStr, patt: availPatt)
                                if availArr.count > 0 {
                                    lesson.availability = availArr[0]
                                }
                                
                                // URL
                                let urlPatt = "href=\"(http://\\D*?\\.dnevnik\\.ru/lesson\\.aspx.*?)\">"
                                let urlArr = self.parseString(lessonBigStr, patt: urlPatt)
                                if urlArr.count > 0 {
                                    lesson.url = urlArr[0]
                                }
                                
                                //println("lesson: \(lesson.subjectName), url: \(lesson.url)")
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                self.marksDays.append(dnevnikDay!)
                                //actInd.stopAnimating()
                                //self.tableView.hidden = false
                                //self.tableView.reloadData()
                            })

                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    //self.marksDays.append(dnevnikDay!)
                    actInd.stopAnimating()
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
        parsePage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if marksDays.count == 0 {
            parsePage()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.marksDays.count
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


}
