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
    @IBOutlet var postPerDayLabel: UILabel!
    @IBOutlet var timeBetweenPostsLabel: UILabel!
    @IBOutlet var postsSchedulingView: UIView!
    @IBOutlet var postsPerDaySlider: UISlider!
    @IBOutlet var timeBetweenPostsSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSavedSettings()

        // Do any additional setup after loading the view.
        if !notificationsSwitch.on {
            println("switch is off")
           self.postsSchedulingView.hidden = true
        } else {
            self.postsSchedulingView.hidden = false
        }
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
    
    
    
    // MARK: - Notifications
    @IBAction func notificationOptionChanged(sender: UISwitch) {
        if sender.on {
            println("switch is on")
            self.registerForNotifications()
            self.postsSchedulingView.hidden = false
        } else {
            println("swithc is off")
            self.postsSchedulingView.hidden = true
        }
    }

    
    
    func registerForNotifications(){
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))  // types are UIUserNotificationType members
    }
    
    
    
    @IBAction func postsPerDayChanged(sender: UISlider) {
        let posts = Int(sender.value)
        self.postPerDayLabel.text = String(posts)
        DataSource.sharedInstance.postsPerDay = posts
    }
    
    
    @IBAction func timeBetweenPostsChanged(sender: UISlider) {
        let timeBetweenPosts = Int(sender.value)
        self.timeBetweenPostsLabel.text = String(timeBetweenPosts)
        DataSource.sharedInstance.timeBetweenPosts = timeBetweenPosts
    }
    
    
    
    @IBAction func scheduleNotifications(sender: UIButton) {
        DataSource.sharedInstance.timeBetweenPosts = Int(self.timeBetweenPostsSlider.value)
        DataSource.sharedInstance.postsPerDay = Int(self.postsPerDaySlider.value)
        DataSource.sharedInstance.remindToPost = self.notificationsSwitch.on
        DataSource.sharedInstance.scheduleNotifications()
        DataSource.sharedInstance.savePostingPreferences()
    }
    
    
    // MARK: - Saved Settings
    func retrieveSavedSettings(){
        let settings = NSUserDefaults.standardUserDefaults()
        let settingsPosts = settings.integerForKey("postsPerDay")
        self.postsPerDaySlider.value = Float(settingsPosts)
        self.postPerDayLabel.text = String(settingsPosts)
        
        self.notificationsSwitch.on = settings.boolForKey("remindToPost")
        
        
        let postInterval = settings.integerForKey("timeBetweenPosts")
        self.timeBetweenPostsSlider.value = Float(postInterval)
        self.timeBetweenPostsLabel.text = String(postInterval)
        
    }

}
