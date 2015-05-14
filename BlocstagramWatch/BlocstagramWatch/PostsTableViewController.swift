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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("view will appear")
        checkAndSetLoginIfNeeded()
    }
    
    
    
    func checkAndSetLoginIfNeeded (){
        if DataSource.sharedInstance.accessToken == nil {
            println("no access token - need one")
            
            
            
            let instaLoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("InstaLoginVC") as! UIViewController
            self.presentViewController(instaLoginVC, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        // sample images to test
//        for var i = 1; i <= 10; i++ {
//            let imageName = "\(i).jpg"
//            let image = UIImage(named: imageName)
//            if ((image) != nil) {
//                self.images.append(image!)
//            }
//            
//            println("number of images \(self.images.count)")
//        }
        
        // test shared dataSource
        var datasourceCount = DataSource.sharedInstance.mediaItems.count
        println("numer of images in datasource is \(datasourceCount)")
        

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
        let imageView = headerCell.profileImage as UIImageView
        let url = mediaItem.user?.profilePictureURL
        imageView.hnk_setImageFromURL(url!)
        

         headerCell.usernameLabel.text = mediaItem.user?.userName as? String
        
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PostsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostsTableViewCell

        // Configure the cell...
//        cell.postComments.text = "test"
        

        cell.postImage.image = UIImage(named: "TestImage.JPG")
        
        // move this code into parser function
        let mediaItem = DataSource.sharedInstance.parsedMediaItems[indexPath.section]
        let imageView = cell.postImage
        let url = mediaItem.mediaURL
        imageView.hnk_setImageFromURL(url!)
        
        cell.postCaption.text = mediaItem.caption as? String
        
        if mediaItem.comments.count > 0 {
        cell.postComments.text = mediaItem.comments[0].text as? String
        }
        
        return cell
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

    
    
    
    
    @IBAction func reloadButton(sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        DataSource.sharedInstance.retrieveDataFromInsta()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    
}
