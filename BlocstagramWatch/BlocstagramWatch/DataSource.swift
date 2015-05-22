//
//  DataSource.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import SwiftyJSON
import SwiftSpinner

class DataSource: NSObject {
   
    
    static let sharedInstance = DataSource()

    var mediaItems: [SwiftyJSON.JSON] = []
    let instagramClientID : NSString = "5e2dd10b29ab44d6ab921c4b1b34a5ed"
    var accessToken: String?
    var parsedMediaItems: Array <Media> = []
    var minID = ""
    var maxID = ""
    var isRefreshing: Bool = false
    var pullToRefresh: Bool = false
    
    // variables related to posts
    var postsPerDay: Int?
    var timeBetweenPosts: Int?
    var remindToPost: Bool = false
    var postsToday: Int?
    var lastPostDate: NSDate?
    
    
    
    
    enum theRequestType {
        case firstLoad
        case pullToRefresh
        case infiniteScroll
    }
    

    
    override init(){
        super.init()
        retrieveSettings()
    }
    
    
    func retrieveSettings(){
        println("retrieving settings")
        
        let settings = NSUserDefaults.standardUserDefaults()
        self.postsPerDay = settings.integerForKey("postsPerDay")
        self.remindToPost = settings.boolForKey("remindToPost")
        self.timeBetweenPosts = settings.integerForKey("timeBetweenPosts")
        self.postsToday = settings.integerForKey("postsToday")
        self.lastPostDate = settings.valueForKey("lastPostDate") as? NSDate
        
    }
    
    
    
    
    func retrieveDataFromInsta(successBlock: Void -> Void){
        
        println("******* retrieving data from insta *******")
        
        // to test have set as > but should be >=
        if parsedMediaItems.count >= 1{
            let minMedia = parsedMediaItems[0] as Media
            minID = minMedia.idNumber as! String
        }
        
        
        if !self.isRefreshing && self.accessToken != nil {
            self.isRefreshing = true
            Alamofire.request(.GET, "https://api.instagram.com/v1/users/self/feed?access_token=\(accessToken!)&min_id=\(minID)").responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["data"].arrayValue as [SwiftyJSON.JSON]?{
                        self.mediaItems = data
                        println(self.mediaItems)
                        println(self.mediaItems.count)
                        self.parseData(theRequestType.firstLoad)
                        println(self.parsedMediaItems.count) // checking items
                        successBlock()
                        
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    func parseData(requestType: theRequestType){
        
        let rawData = self.mediaItems
        var tempParsedMediaItems: Array <Media> = []
        for item in rawData {

            let mediaItem = Media(mediaDictionary: item)
            
            let tmpMinID = mediaItem.idNumber
            
            tempParsedMediaItems.append(mediaItem)
        }
        
        if requestType == theRequestType.infiniteScroll {
            println("parsing older data with \(tempParsedMediaItems.count)")
            self.parsedMediaItems += tempParsedMediaItems
            
            return
        }
        
        
        if self.pullToRefresh {
            tempParsedMediaItems += self.parsedMediaItems
            self.parsedMediaItems = tempParsedMediaItems
            self.pullToRefresh = false
        } else {
            self.parsedMediaItems += tempParsedMediaItems
        }
        self.isRefreshing = false
    }
    
    
    
    
    
    
    
    func retrieveOlderDataFromInsta(successBlock: Void -> Void){
        
        println("******* retrieving OLD data from insta *******")
        
        // to test have set as > but should be >=
        if parsedMediaItems.count >= 1{
            let maxMedia = parsedMediaItems[parsedMediaItems.count - 1] as Media
            maxID = maxMedia.idNumber as! String
        }
        
        
        if self.accessToken != nil {
            Alamofire.request(.GET, "https://api.instagram.com/v1/users/self/feed?access_token=\(accessToken!)&max_id=\(maxID)").responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["data"].arrayValue as [SwiftyJSON.JSON]?{
                        self.mediaItems = data
                        //                    println(self.mediaItems)
                        println(self.mediaItems.count)
                        self.parseData(theRequestType.infiniteScroll)
                        println(self.parsedMediaItems.count) // checking items
                        successBlock()
                        
                    }
                }
            }
        }
        
        
        
    }

    
    
    
    func userLikesMedia (mediaitem: Media){
        
        
        let parameters = ["access_token": self.accessToken!]
        
        Alamofire.request(.POST, "https://api.instagram.com/v1/media/\(mediaitem.idNumber)/likes", parameters: parameters)
        
    }
    
    
    
    
    // MARK: - Notifications
    
    
    func registerForNotifications(){
        
        // Post Action
        let postAction = UIMutableUserNotificationAction()
        postAction.identifier = "POST_ACTION"
        postAction.title = "Post Now"
        postAction.activationMode = UIUserNotificationActivationMode.Background
        postAction.authenticationRequired = true
        postAction.destructive = false
        
        
        // 2. Create the category ***********************************************
        
        // Category
        let postCategory = UIMutableUserNotificationCategory()
        postCategory.identifier = "POST_CATEGORY"
        
        // A. Set actions for the default context
        postCategory.setActions([postAction],
        forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        postCategory.setActions([postAction],
        forContext: UIUserNotificationActionContext.Minimal)
        
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: postCategory) as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
//        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
    }

    
    
    
    
    func scheduleNotifications(){
        println("*** scheduling notifications ***")
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        for i in 1...self.postsPerDay!{
            println("creating notification")
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Post to Instagram"
            localNotification.alertBody = "Reach your publishing goal. Post to Instagram now."
            localNotification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            localNotification.fireDate = NSDate(timeIntervalSinceNow: Double(self.timeBetweenPosts!*i*10))
            localNotification.category = "POST_CATEGORY"
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        println(UIApplication.sharedApplication().scheduledLocalNotifications)
        
    }
    
    
    
    
    func saveSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setInteger(postsPerDay!, forKey: "postsPerDay")
        settings.setInteger(timeBetweenPosts!, forKey: "timeBetweenPosts")
        settings.setBool(remindToPost, forKey: "remindToPost")
        
        if let postsDoneToday = self.postsToday {
            settings.setInteger(postsDoneToday, forKey: "postsToday")
        }
        
        if let postDate = self.lastPostDate {
            settings.setValue(postDate, forKey: "lastPostDate")
        }
    }
    
    
    
    
    func lookForNotificationsTodayButAfterNow() -> (todaysNotifications:[UILocalNotification], otherNotifications:[UILocalNotification]){
        let localnotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        var todaysNotifications: [UILocalNotification] = []
        var otherNotifications: [UILocalNotification] = []
        
        for i in localnotifications {
            let fireDate = i.fireDate!
            
            let isToday: Bool = NSCalendar.currentCalendar().isDateInToday(fireDate)
            if isToday {
                println(isToday)
                let dateComparison = NSDate().compare(fireDate)
                if dateComparison == NSComparisonResult.OrderedAscending {
                    println(i)
                    todaysNotifications.append(i as! UILocalNotification)
                } else {
                    otherNotifications.append(i as! UILocalNotification)
                }
            } else {
                otherNotifications.append(i as! UILocalNotification)
            }
        }
        return (todaysNotifications, otherNotifications)
    }
    
    
    // MARK: - Posts
    
    func postAPic(){
        // there is a postDate
        if let postDate = self.lastPostDate{
            // check if its today
            if NSCalendar.currentCalendar().isDateInToday(postDate){
            // if yes then increment the post count
                if let postsCount = self.postsToday{
                    self.postsToday! += 1
                } else {
                    self.postsToday = 1
                }
                
            } else{
                // if not then replace the date
                // and reset the post count
                self.lastPostDate = NSDate()
                self.postsToday = 1
            }
        } else {
            println("no current post date")
            self.lastPostDate = NSDate() // if the date is currently nil then set it to now
            self.postsToday = 1
        }
        
        println("posts taken today \(self.postsToday)")
        adjustNotifications()
    }
    
    
    
    func adjustNotifications(){
        var notificationsLeftForToday = lookForNotificationsTodayButAfterNow().todaysNotifications
        
        // posts left to do for the day should match notifications left for today
        //
        let postsLeftForToday = max(0,postsPerDay! - postsToday!)
        let notificationsToReschedule = max(0, notificationsLeftForToday.count - postsLeftForToday)
        
        println("Taken \(self.postsToday) of \(self.postsPerDay) with \(notificationsLeftForToday.count) notifications left out of a total of \(UIApplication.sharedApplication().scheduledLocalNotifications.count)")
        if notificationsToReschedule > 0 {
            for i in 0...notificationsToReschedule-1 {
                let tempNotification = notificationsLeftForToday[i]
                let currentFireDate = tempNotification.fireDate
                
                
                let newFireDate = NSCalendar.currentCalendar().dateByAddingUnit(
                    .CalendarUnitDay,
                    value: 1,
                    toDate: currentFireDate!,
                    options: nil)!
                
                tempNotification.fireDate = newFireDate
                notificationsLeftForToday[i] = tempNotification
                
            }
            
            let newScheduledNotifications = notificationsLeftForToday + lookForNotificationsTodayButAfterNow().otherNotifications
            
            UIApplication.sharedApplication().scheduledLocalNotifications = newScheduledNotifications
        }
    }
    
    
    
}
