//
//  ViewController.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 03.10.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit
//import "SWRevealViewController.h"
//import SWRevealViewController

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {//, DHNetworkManagerDelegate {
    @IBOutlet var headerLabel : UILabel!
    @IBOutlet var fullnameLabel : UILabel!
    @IBOutlet var userName : UITextField!
    @IBOutlet var password : UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sidebarButton : UIBarButtonItem!
    var xss : String?
    
    func saveStoredCookies() -> Void {
        let httpURL = NSURL(string: "http://dnevnik.ru")
        let htpCookies = NSHTTPCookieStorage()
        var cookies: [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as [NSHTTPCookie]
        
    }
    
    func parseString(str : String, patt : String, full : Bool = false) -> [String] {
        let regManager = RegexManager(patt)
        if full == false {
            return regManager.test(str) as [String]
        }
        return regManager.gefFull(str) as [String]
    }

    func setupMenuButtonAction() {
        if (revealViewController() != nil) {
            //sidebarButton.tintColor = UIColor.darkGrayColor()
            sidebarButton.target = revealViewController()
            sidebarButton.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func changeUrls(str : String) {
        // для аккаунтов учеников, оказывается урлы другие
        // у учеников нет ссылок на children.dnevnik.ru
        let patt = "\"(EduStudent)\""
        let regManager = RegexManager(patt)
        var regArr = regManager.test(str) as [String]
        if regArr.count > 0  {
            Global.timetableUrl = "http://schools.dnevnik.ru/schedules"
            Global.marksUrl = "http://schools.dnevnik.ru/marks.aspx"
        } else {
            Global.timetableUrl = "http://children.dnevnik.ru/timetable.aspx"
            Global.marksUrl = "http://children.dnevnik.ru/marks.aspx"
        }
    }
    
    func getXss() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        println(Global.loginUrl)
        let reqUrl = NSURL(string: Global.loginUrl)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                let fullStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //println("DATA: \n \(fullStr!)")
                let patt = "\\s*name=\"xss\"\\s*value=\"(.*?)\".*?/>"
                
                let regManager = RegexManager(patt)
                self.xss = regManager.test(fullStr!)[0] as NSString
                //println("test: \(regManager.test(fullStr!))")
//                self.headerLabel.text = self.xss
                
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Ой, всё!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            actInd.stopAnimating()
        }
    }
    
    func getFullName() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.fullnameLabel.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        let reqUrl = NSURL(string: Global.loginUrl)
        let request = NSURLRequest(URL:reqUrl!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        var fullNameText = ""

        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {response,data,error in
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                let fullStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let patt = "<a\\s*?href=\"http://dnevnik.ru/user/user.aspx.*?\".*?>(.*?)</a>"
                
                let regManager = RegexManager(patt)
                let fullNameArr = regManager.test(fullStr!)
                //println("fname = \(fullNameArr)")
                fullNameText = regManager.test(fullStr!)[0] as NSString
                dispatch_async(dispatch_get_main_queue(), {
                    self.fullnameLabel.text = fullNameText
                    self.changeUrls(fullStr!)
                    actInd.stopAnimating()
                })
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Ой, всё!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
        }
        //self.fullnameLabel.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DnevnikApp"
        
        setupMenuButtonAction()
        
        self.fullnameLabel.font = UIFont.boldSystemFontOfSize(18)
        self.fullnameLabel.textColor = UIColor(red: 125/255, green: 184/255, blue: 45/255, alpha: 1)
        
        if Global.signedIn {
            //getFullName()
            self.headerLabel.text = "Вы вошли, как"
            //self.fullnameLabel.text = "Фамилия Имя Отчество"
            self.userName.hidden = true
            self.password.hidden = true
            self.loginButton.setTitle("Выйти", forState: nil) //titleLabel?.text = "Выйти"
        } else {
            self.headerLabel.text = "Вы не вошли в систему"
            self.fullnameLabel.text = "Войти:"
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if Global.signedIn {
            getFullName()
        } else {
            if self.xss == nil {
                getXss()
            }
        }
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center //self.fullnameLabel.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(actInd)
        actInd.startAnimating()

        
        if userName.text != "" {
            let params = "xss=\(self.xss)&returnUrl=&Login=\(userName.text)&Password=\(password.text)"
            
            let reqUrl = NSURL(string: Global.loginUrl)
            let request = NSMutableURLRequest(URL:reqUrl!)
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            
            var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var error : NSErrorPointer = nil
            var data : NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)!

            //let queue : NSOperationQueue = NSOperationQueue.mainQueue()
        //NSURLConnection.sendAsynchronousRequest(request, queue: queue)
            //{
                //(response : NSURLResponse!, data : NSData!, error : NSError!) in
                //if response != nil {
                //    let resp = response as NSHTTPURLResponse
                    //println("RESPONSE: \(resp.statusCode)")
                //}
                //if data != nil {
                    var fullStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let patt = "<dt>Я забыл логин"
            
                    let regManager = RegexManager(patt)
                    let loginErrorArr = parseString(fullStr!, patt: patt, full: true) //regManager.test(fullStr!)
                    if loginErrorArr.count == 0 {
                        
                    // для аккаунтов учеников, оказывается урлы другие
                    // у учеников нет ссылок на children.dnevnik.ru
                    self.changeUrls(fullStr!)

                    Global.signedIn = true
                    //println("TimeTable URL: \(Global.timetableUrl)")
                    //println("Marks URL: \(Global.marksUrl)")
                    }
                //}
                
                if error != nil {
                    let alert = UIAlertView(title:"Ой, всё!",message:error.debugDescription, delegate:nil, cancelButtonTitle:"OK")
                    alert.show()
                }
            //}
            
            

        }  else {
            // удалим куки
            let cookieStor = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            var cookies = cookieStor.cookies as [NSHTTPCookie]
            for c in cookies {
                if c.domain == ".login.dnevnik.ru" {
                    cookieStor.deleteCookie(c)
                    //println("KOOKIE DELETED: \(c.name)")
                }
                Global.signedIn = false
            }
        }
        
        
        actInd.stopAnimating()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc: AnyObject! = storyBoard.instantiateViewControllerWithIdentifier("userNavigationController")
        let rc : SWRevealViewController = self.revealViewController()
        rc.pushFrontViewController(vc as UINavigationController, animated: true)

        //return
        // Здесь нужно проверить, что логин прошел успешно.
        // Если все ОК, делаем переход на страницу с оценками,
        // если нет, выбросим окошко с ошибкой и останемся тут
        
        // Нужно также отработать запрет возможности переходов на другие страницы, если входа не было
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

