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

class DataSource: NSObject {
   
    
    static let sharedInstance = DataSource()

    var mediaItems: [SwiftyJSON.JSON] = []
    let instagramClientID : NSString = "5e2dd10b29ab44d6ab921c4b1b34a5ed"
    var accessToken: String?
    var parsedMediaItems: Array <Media> = []
    var minID = ""
    var isRefreshing: Bool = false
    var pullToRefresh: Bool = false

    
    override init() {
        super.init()

        
        // temporary cheat => login should be called BEFORE datasource
        accessToken = "6516672.5e2dd10.41ed4ad67a2442e0ae130d3e13e88e40"
//        retrieveDataFromInsta()
    }
    
    
    
    func retrieveDataFromInsta(){
        
        // to test have set as > but should be >=
        if parsedMediaItems.count >= 1{
            let minMedia = parsedMediaItems[0] as Media
            minID = minMedia.idNumber as! String
        }
        
        
        if !self.isRefreshing {
            self.isRefreshing = true
            Alamofire.request(.GET, "https://api.instagram.com/v1/users/self/feed?access_token=\(accessToken!)&min_id=\(minID)").responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["data"].arrayValue as [SwiftyJSON.JSON]?{
                        self.mediaItems = data
                        //                    println(self.mediaItems)
                        println(self.mediaItems.count)
                        self.parseData()
                        println(self.parsedMediaItems.count) // checking items
                        
                        
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    func parseData(){
        
        let rawData = self.mediaItems
        var tempParsedMediaItems: Array <Media> = []
        for item in rawData {

            let mediaItem = Media(mediaDictionary: item)
            
            let tmpMinID = mediaItem.idNumber
            
            tempParsedMediaItems.append(mediaItem)
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
    
    
    
    
}
