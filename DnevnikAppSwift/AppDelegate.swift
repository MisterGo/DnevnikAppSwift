//
//  AppDelegate.swift
//  DnevnikAppSwift
//
//  Created by Антон Гоголев on 03.10.14.
//  Copyright (c) 2014 Антон Гоголев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //registering for sending user various kinds of notifications
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))
        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(UIUserNotificationType.Sound |
//            UIUserNotificationType.Alert |
//            UIUserNotificationType.Badge) //, categories: nil)
        //
        
        let cookieStor = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        //println("CookieStor: \(cookieStor.description)")
        let cookies = cookieStor.cookies as! [NSHTTPCookie]
        for c in cookies {
            if c.domain == ".login.dnevnik.ru" {
                //println(" - \(c.domain) - \(c.name) - \(c.value) - \(c.expiresDate)\n")
                let cookieEndDate = c.expiresDate
                let interval = cookieEndDate.timeIntervalSinceNow
                //println("Interval = \(interval)")
                if interval > 0 {
                    Global.signedIn = true
                }
                return true
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

