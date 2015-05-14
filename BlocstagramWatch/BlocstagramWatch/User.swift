//
//  User.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import SwiftyJSON

class User: NSObject {
    
    
    var idNumber: NSString?
    var userName: NSString?
    var fullName: NSString?
    var profilePictureURL: NSURL?
    var profilePicture: UIImage?
    
    
    
    
        
        
        ////        let data = DataSource.sharedInstance.mediaItems[indexPath.section]
        //        if let imageView = cell.viewWithTag(101) as? UIImageView {
        //            if let urlString = data["images"]["standard_resolution"]["url"].string{
        //                let url = NSURL(string: urlString)
        //                imageView.hnk_setImageFromURL(url!)
        //            }


//        super.init()
        
    
    
    
    
    init (userDicionary: SwiftyJSON.JSON){
        self.idNumber = userDicionary["id"].string
        self.userName = userDicionary["username"].string
        self.fullName = userDicionary["full_name"].string
        
        if let urlString = userDicionary["profile_picture"].string {
            self.profilePictureURL = NSURL(string: urlString)
//            self.profilePicture.hnk_setImageFromURL(profilePictureURL!)
        }
        
    }
    
   
}
