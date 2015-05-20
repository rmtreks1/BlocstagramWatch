//
//  SettingsViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 20/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var loginLogout: UIBarButtonItem!
    @IBOutlet var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    // MARK: - Logout
    @IBAction func logout(sender: UIBarButtonItem) {
        println("logout pressed")
        DataSource.sharedInstance.accessToken = nil
        DataSource.sharedInstance.parsedMediaItems = []
        DataSource.sharedInstance.mediaItems = []
        clearInstagramCookies()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func clearInstagramCookies () {
        var storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies  as! [NSHTTPCookie]{
            println(cookie.domain)
            if let instaCookieFound = cookie.domain.rangeOfString("instagram.com") {
                storage.deleteCookie(cookie)
                println("deleted \(cookie.domain)")
                
            }
        }
    }
    
    
    @IBAction func notificationOptionChanged(sender: UISwitch) {
        if sender.on {
            println("switch is on")
        } else {
            println("swithc is off")
        }
    }

    

}
