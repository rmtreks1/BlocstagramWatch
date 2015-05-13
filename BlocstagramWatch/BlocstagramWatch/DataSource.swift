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


//    override convenience init() {
//        self.init()
//        
//    }

    override init() {
        super.init()
//        self.mediaItems = []
//        self.init()
//        sampleData()
        
        // temporary cheat => login should be called BEFORE datasource
        accessToken = "6516672.5e2dd10.41ed4ad67a2442e0ae130d3e13e88e40"
        retrieveDataFromInsta()
    }
    
//    func sampleData(){
//        for var i = 1; i <= 10; i++ {
//            let imageName = "\(i).jpg"
//            let image = UIImage(named: imageName)
//            if ((image) != nil) {
//                self.mediaItems.append(image!)
//            }
//            
//            println("number of images \(self.mediaItems.count)")
//        }
//    }
    
    
    func retrieveDataFromInsta(){
        Alamofire.request(.GET, "https://api.instagram.com/v1/users/self/feed?access_token=\(accessToken!)").responseJSON { (request, response, json, error) in
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["data"].arrayValue as [SwiftyJSON.JSON]?{
                    self.mediaItems = data
                    println(self.mediaItems)

                }
            }
        }
    }
    
}
