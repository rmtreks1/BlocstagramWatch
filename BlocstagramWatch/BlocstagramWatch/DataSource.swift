//
//  DataSource.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class DataSource: NSObject {
   
    
    static let sharedInstance = DataSource()

    var mediaItems: [AnyObject] = []
    let instagramClientID : NSString = "5e2dd10b29ab44d6ab921c4b1b34a5ed"
    

//    override convenience init() {
//        self.init()
//        
//    }

    override init() {
        super.init()
//        self.mediaItems = []
//        self.init()
        sampleData()
    }
    
    func sampleData(){
        for var i = 1; i <= 10; i++ {
            let imageName = "\(i).jpg"
            let image = UIImage(named: imageName)
            if ((image) != nil) {
                self.mediaItems.append(image!)
            }
            
            println("number of images \(self.mediaItems.count)")
        }
    }
    
}
