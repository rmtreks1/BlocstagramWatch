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
    var comments: NSArray?
    
    
    
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
        

        
        
    }
    
    
    
    
}
