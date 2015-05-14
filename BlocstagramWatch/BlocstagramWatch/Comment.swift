//
//  Comment.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import SwiftyJSON


class Comment: NSObject {
    
    var idNumber: NSString?
    var from: User?
    var text: NSString?

    
    
    
    init (commentDictionary: SwiftyJSON.JSON){
        
        self.idNumber = commentDictionary["id"].string
        self.text = commentDictionary["text"].string
        self.from = User(userDicionary: commentDictionary["from"])
        }
        
    }
