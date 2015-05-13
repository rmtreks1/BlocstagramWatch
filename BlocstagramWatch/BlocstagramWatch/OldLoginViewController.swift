//
//  LoginViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    var redirectURI: NSString = "http://www.yourfork.com.au"
    
    
    
    
    override func loadView() {
 //       webView = UIWebView()
//        webView.delegate = self
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        var urlString = "https://instagram.com/oauth/authorize/?client_id=\(DataSource.sharedInstance.instagramClientID)&redirect_uri=\(redirectURI)&response_type=token"
//
//        var url = NSURL(string: urlString)
//        
//        
//        if ((url) != nil) {
//            var request = NSMutableURLRequest(URL: url!)
////            webView.loadRequest(request)
//        }

        
        let testurl = NSURL (string: "http://www.apple.com");
        let requestObj = NSURLRequest(URL: testurl!);
//        webView.loadRequest(requestObj);
        
        
        
    }
    
    // code as per Bloc checkpoint
//    deinit{
//        self.webView.delegate = nil
//    }
//    
//    

    
    
    

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
