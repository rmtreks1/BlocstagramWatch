//
//  GlanceController.swift
//  BlocstagramWatch WatchKit Extension
//
//  Created by Roshan Mahanama on 21/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var testLabel: WKInterfaceLabel!
    @IBOutlet var progressImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        
       
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        refreshPostsLeftCount()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    func refreshPostsLeftCount(){
        GlanceController.openParentApplication(["request": "refreshData"], reply: { (replyInfo, error) -> Void in
            // TODO: process reply data
            //            NSLog("Reply: \(replyInfo)")
            let postsLeft = String(replyInfo["postsLeft"] as! Int)
            self.testLabel.setText("\(postsLeft) left")
            
            let progressImageName = replyInfo["progressImage"] as! String
            self.progressImage.setImageNamed(progressImageName)
        })
    }
    
   
}
