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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        
       
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        GlanceController.openParentApplication(["request": "refreshData"], reply: { (replyInfo, error) -> Void in
            // TODO: process reply data
            //            NSLog("Reply: \(replyInfo)")
            let postsLeft = replyInfo["postsLeft"] as! Int
            self.testLabel.setText(String(postsLeft))
        })
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
