//
//  PostsTableViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var images = [UIImage]()
    
    @IBOutlet var logoutButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("***** viewWillAppear *****")
        checkAndSetLoginIfNeeded()
//        
//        
//        
//        if DataSource.sharedInstance.accessToken == nil {
//            println("***** viewWillAppear no access token *****")
//            checkAndSetLoginIfNeeded()
//        }
//        
//        
//        if DataSource.sharedInstance.accessToken != nil {
//            println("******* viewWillAppear: retrieving data *******")
//            DataSource.sharedInstance.retrieveDataFromInsta({
//                self.tableView.reloadData()
//            })
//        }
//

    }
    
    
    
    func checkAndSetLoginIfNeeded (){
        if DataSource.sharedInstance.accessToken == nil {
            self.navigationItem.leftBarButtonItem = nil
            println("no access token - need one")
            let instaLoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("InstaLoginVC") as! UIViewController
            self.presentViewController(instaLoginVC, animated: true, completion: nil)
        } else {
            self.navigationItem.leftBarButtonItem = logoutButton
            println("******** checkAndSetLogin: retrieving data *******")
            DataSource.sharedInstance.retrieveDataFromInsta({
                self.tableView.reloadData()
            })
        }
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test shared dataSource
//        var datasourceCount = DataSource.sharedInstance.mediaItems.count
//        
//        
//        if DataSource.sharedInstance.accessToken == nil {
//            println("***** viewDidLoad no access token *****")
//            checkAndSetLoginIfNeeded()
//        }
//        
//        
//        if DataSource.sharedInstance.accessToken != nil {
//            println("******* viewDidLoad: retrieving data *******")
//            DataSource.sharedInstance.retrieveDataFromInsta()
//        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return DataSource.sharedInstance.parsedMediaItems.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! PostsHeaderTableViewCell
        
        let mediaItem = DataSource.sharedInstance.parsedMediaItems[section]
        headerCell.setMedia(mediaItem)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 444
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PostsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostsTableViewCell


        

        cell.postImage.image = UIImage(named: "TestImage.JPG")
        
        let mediaItem = DataSource.sharedInstance.parsedMediaItems[indexPath.section]
        
        cell.setMedia(mediaItem)
        
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let currentSection = indexPath.section
        let mediaItemCount = DataSource.sharedInstance.parsedMediaItems.count
        println("\(currentSection) of \(mediaItemCount) ")
        
        if mediaItemCount > 5 {
            let triggerPoint = mediaItemCount - 3
            if currentSection > triggerPoint {
                println("fetch older items")
                DataSource.sharedInstance.retrieveOlderDataFromInsta({
                    println("retrieve old data finished")
                })
            }
        }
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        
        DataSource.sharedInstance.pullToRefresh = true
        DataSource.sharedInstance.retrieveDataFromInsta({
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
        

        
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        println("logout pressed")
        DataSource.sharedInstance.accessToken = nil
        DataSource.sharedInstance.parsedMediaItems = []
        DataSource.sharedInstance.mediaItems = []
        self.tableView.reloadData()
        clearInstagramCookies()
        checkAndSetLoginIfNeeded()
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
    
    
    
}
