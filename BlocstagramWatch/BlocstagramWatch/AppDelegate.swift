//
//  AppDelegate.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
        println("app is back")
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshData", object: nil);
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        // Handle notification action *****************************************
        if notification.category == "POST_CATEGORY" {
            println("notification received")
        }
        
        
        completionHandler()
        
    }
    
    
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        
        if let userInfo = userInfo, request = userInfo["request"] as? String {
            if request == "refreshData" {

                let postsLeft = max(0,DataSource.sharedInstance.postsPerDay! - DataSource.sharedInstance.postsToday!)
                println("posts left according to ios app \(postsLeft)")
                
                let progress = min(1,Float(DataSource.sharedInstance.postsToday!)/Float(DataSource.sharedInstance.postsPerDay!))
                
                // converting to base 44, as the watch app has 44 images to show progress circle
                let progressIn44 = Int(progress * 44)
                println(progressIn44)
                
                let progressImage = "glance-\(progressIn44)" as String
                
                reply(["postsLeft": postsLeft,"progressImage":progressImage])
                return
            }
        }
        
        reply([:])
    }
    
   

}

