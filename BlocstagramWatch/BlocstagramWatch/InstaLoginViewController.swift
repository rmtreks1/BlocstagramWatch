//
//  InstaLoginViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class InstaLoginViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    let redirectURI: NSString = "http://www.yourfork.com.au"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlString: NSString = "https://instagram.com/oauth/authorize/?client_id=\(DataSource.sharedInstance.instagramClientID)&redirect_uri=\(redirectURI)&response_type=token"
        
        
        let url = NSURL (string: urlString as String)
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
