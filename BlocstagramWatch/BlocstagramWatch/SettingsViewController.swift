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
           self.postsSchedulingView.hidden = true
        } else {
            self.postsSchedulingView.hidden = false
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("view will disappear")
        // save settings on exit from view
        if self.notificationsSwitch.on {
            scheduleTheNotifications()
        } else {
            DataSource.sharedInstance.disableAllNotifications()
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
            setDefaultValues()
            DataSource.sharedInstance.registerForNotifications()
            self.postsSchedulingView.hidden = false
        } else {
            println("swithc is off")
            self.postsSchedulingView.hidden = true
//            DataSource.sharedInstance.disableAllNotifications()
        }
    }

    
    func setDefaultValues(){
        self.postPerDayLabel.text = String(1)
        self.postsPerDaySlider.value = Float(1)
        self.timeBetweenPostsLabel.text = String(5)
        self.timeBetweenPostsSlider.value = Float(5)
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
    
    
    func scheduleTheNotifications(){
        DataSource.sharedInstance.timeBetweenPosts = Int(self.timeBetweenPostsSlider.value)
        DataSource.sharedInstance.postsPerDay = Int(self.postsPerDaySlider.value)
        DataSource.sharedInstance.remindToPost = self.notificationsSwitch.on
        DataSource.sharedInstance.scheduleNotifications()
        DataSource.sharedInstance.saveSettings()
    }
    
    
    
    
    
   // test function
//    @IBAction func findNotificationsForRestOfToday(sender: UIButton) {
//        println("today's notifications:\(DataSource.sharedInstance.lookForNotificationsTodayButAfterNow().todaysNotifications.count) out of \(DataSource.sharedInstance.lookForNotificationsTodayButAfterNow().todaysNotifications.count + DataSource.sharedInstance.lookForNotificationsTodayButAfterNow().otherNotifications.count) ")
//    }
    
    
    
    
    
    
    // MARK: - Saved Settings
    func retrieveSavedSettings(){
        self.notificationsSwitch.on = DataSource.sharedInstance.remindToPost
        self.postsPerDaySlider.value = Float(DataSource.sharedInstance.postsPerDay!)
        self.postPerDayLabel.text = String(DataSource.sharedInstance.postsPerDay!)
        self.timeBetweenPostsSlider.value = Float(DataSource.sharedInstance.timeBetweenPosts!)
        self.timeBetweenPostsLabel.text = String(DataSource.sharedInstance.timeBetweenPosts!)
        
    }

}
