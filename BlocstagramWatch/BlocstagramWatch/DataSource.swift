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
    
    
    
    
    enum theRequestType {
        case firstLoad
        case pullToRefresh
        case infiniteScroll
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
    
    func scheduleNotifications(){
        println("*** scheduling notifications ***")
        
        for i in 1...self.postsPerDay!{
            println("creating notification")
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Post to Instagram"
            localNotification.alertBody = "Reach your publishing goal. Post to Instagram now."
            localNotification.repeatInterval = NSCalendarUnit.CalendarUnitDay
            localNotification.fireDate = NSDate(timeIntervalSinceNow: Double(self.timeBetweenPosts!*i*60))
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        println(UIApplication.sharedApplication().scheduledLocalNotifications)
        
    }
    
    
    
    
    func savePostingPreferences(){
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setInteger(postsPerDay!, forKey: "postsPerDay")
        settings.setInteger(timeBetweenPosts!, forKey: "timeBetweenPosts")
        settings.setBool(remindToPost, forKey: "remindToPost")
    }
    
    
    
    
    
}
