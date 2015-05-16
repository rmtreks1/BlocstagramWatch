//
//  Media.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import SwiftyJSON


class Media: NSObject {
   
    var idNumber: NSString?
    var user: User?
    var mediaURL: NSURL?
    var image: UIImage?
    var caption: NSString?
//    var comments: NSArray?
    var comments: Array <Comment> = []
    
    
    
//    
//    let data = DataSource.sharedInstance.mediaItems[section]
//    let imageView = headerCell.profileImage as UIImageView
//    if let urlString = data["user"]["profile_picture"].string{
//        let url = NSURL(string: urlString)
//        imageView.hnk_setImageFromURL(url!)
//    }

    
    
    init(mediaDictionary: SwiftyJSON.JSON) {
        super.init()
        self.idNumber = mediaDictionary["id"].string!
        self.caption = mediaDictionary["caption"]["text"].string
        
        var imageURL : NSURL
        if let urlString = mediaDictionary["images"]["standard_resolution"]["url"].string{
            self.mediaURL = NSURL(string: urlString)!
        }

        self.user = User(userDicionary: mediaDictionary["user"])
        
        let commentDictionary = mediaDictionary["comments"]["data"]
        println("comments count is \(commentDictionary.count)")
        println(commentDictionary)
       
        let commentCount = commentDictionary.count
        if commentCount >= 1{
            for index in 0...commentCount-1 {
                let commentToAdd = Comment(commentDictionary: commentDictionary[index])
//                self.comments += commentToAdd
                self.comments.append(commentToAdd)
            }
                     println("count post comment parse is \(self.comments.count)")
        }
        

        
        
        
        
        
//        
//        
//        let json = JSONValue(jsonResult)
//        let count: Int? = json["data"].array?.count
//        println("found \(count!) challenges")
//        
//        if let ct = count {
//            for index in 0...ct-1 {
//                // println(json["data"][index]["challengeName"].string!)
//                if let name = json["data"][index]["challengeName"].string {
//                    println(name)
//                }
//                
//            }
//        
        
    }
    
    
    
    
}
