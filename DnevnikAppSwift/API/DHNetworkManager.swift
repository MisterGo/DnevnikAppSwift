//
//  DHNetworkManager.swift
//  MCDopeHood
//
//  Created by Marlow Charite on 8/25/14.
//  Copyright (c) 2014 Marlow Charite. All rights reserved.
//

import UIKit

let hostURL = "http://www.dopehood.se/mobileapi/"

@objc protocol DHNetworkManagerDelegate {
    optional func didLoseInternetConnection()
    optional func didConnectViaWiFi()
    optional func didConnectViaCellularData()
}

class DHNetworkManager: AFHTTPSessionManager {
    
    var delegate: DHNetworkManagerDelegate?
    private var isLoading = false
    private var isOnline = false
    private lazy var reachabilityMangager = AFNetworkReachabilityManager.sharedManager()
    
    struct Singleton {
        static let sharedInstance = DHNetworkManager(url: NSURL(string: hostURL)!)
    }
    
    class var sharedInstance: DHNetworkManager {
        return Singleton.sharedInstance
    }
    
    init(url: NSURL) {
        super.init(baseURL: url, sessionConfiguration: .defaultSessionConfiguration())
        
        self.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
        self.responseSerializer.acceptableContentTypes = NSSet(object: "text/html")

        self.requestSerializer = AFJSONRequestSerializer() as AFHTTPRequestSerializer
        
        setupReachabilityManager()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Use init:(url) for instantiation of this object!!!")
    }
    
    func requestData(url: NSString, requestSucceeded: (dHResponse: AnyObject) -> Void, requestFailed: (error: NSError) -> Void) {
        isLoading = true
       
        let sessionDataTask = self.GET(url,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, response: AnyObject!) -> Void in
                self.isLoading = false
                requestSucceeded(dHResponse: response)
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                self.isLoading = false
                requestFailed(error: error)
        })
    }
    
    private func setupReachabilityManager() {
        reachabilityManager.startMonitoring()

        reachabilityManager.setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            switch status {
                case .NotReachable:
                // we need to notify a delegete when internet connection is lost.
                    self.isOnline = self.reachabilityManager.reachable
                    println("No Internet Connection, online: \(self.isOnline)")
                case .ReachableViaWWAN:
                    self.isOnline = self.reachabilityManager.reachable
                    println("3G, online: \(self.isOnline)")
                case .ReachableViaWiFi:
                    self.isOnline = self.reachabilityManager.reachable
                    println("WIFI, online: \(self.isOnline)")
                default:
                    self.isOnline = self.reachabilityManager.reachable
                    println("Unkown network status, online: \(self.isOnline)")
                    //[operationQueue setSuspended:YES]
            }
        }
    }
    
    func isConnected() -> Bool {
        return isOnline
    }
      
}