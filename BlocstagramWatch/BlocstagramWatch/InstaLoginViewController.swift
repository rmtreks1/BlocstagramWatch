//
//  InstaLoginViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import SwiftSpinner


class InstaLoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    let redirectURI: String = "http://www.yourfork.com.au"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("***** instaLoginVC - viewDidLoad *****")

        // Do any additional setup after loading the view.
        webView.delegate = self
        
        let urlString: NSString = "https://instagram.com/oauth/authorize/?client_id=\(DataSource.sharedInstance.instagramClientID)&redirect_uri=\(redirectURI)&response_type=token"
        
        
        let url = NSURL (string: urlString as String)
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
//        SwiftSpinner.hide()
    }
    
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SwiftSpinner.hide()
    }
    
    
    

    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        var urlString = request.URL!.absoluteString!
        
        if urlString.hasPrefix(redirectURI as String) {
            println("auth token")
            println(urlString)
            
            let rangeOfAccessTokenParameter = urlString.rangeOfString("access_token=")
            
            let accessToken = urlString.substringFromIndex(rangeOfAccessTokenParameter!.endIndex)
            
//            let accessToken = urlString.substringFromIndex(advance(urlString,rangeOfAccessTokenParameter?.endIndex))
            println(rangeOfAccessTokenParameter?.endIndex)
            println(accessToken)
            DataSource.sharedInstance.accessToken = accessToken
            println(DataSource.sharedInstance.accessToken)

            dismissViewControllerAnimated(true, completion: nil)
            
            return false
            
        }
        
        
        
        return true
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
