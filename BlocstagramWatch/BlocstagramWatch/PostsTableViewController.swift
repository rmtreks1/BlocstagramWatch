//
//  PostsTableViewController.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Foundation
import MobileCoreServices

class PostsTableViewController: UITableViewController, PostsHeaderTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    var images = [UIImage]()
    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    var documentController: UIDocumentInteractionController?
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("***** viewWillAppear *****")
        checkAndSetLoginIfNeeded()
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    
    func checkAndSetLoginIfNeeded (){
        SwiftSpinner.show("ET Phone Insta...")
        if DataSource.sharedInstance.accessToken == nil {
            self.navigationItem.leftBarButtonItem = nil
            println("no access token - need one")
            let instaLoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("InstaLoginVC") as! UIViewController
            self.presentViewController(instaLoginVC, animated: true, completion: nil)
        } else {
            self.navigationItem.leftBarButtonItem = logoutButton
            println("******** checkAndSetLogin: retrieving data *******")
            SwiftSpinner.show("Getting goodies from Insta...")
            DataSource.sharedInstance.retrieveDataFromInsta({
                self.tableView.reloadData()
                SwiftSpinner.hide()
            })
        }
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData:", name: "RefreshData", object: nil)
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
        headerCell.delegate = self
        
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
                    self.tableView.reloadData()
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
    
//    @IBAction func logout(sender: UIBarButtonItem) {
//        println("logout pressed")
//        DataSource.sharedInstance.accessToken = nil
//        DataSource.sharedInstance.parsedMediaItems = []
//        DataSource.sharedInstance.mediaItems = []
//        self.tableView.reloadData()
//        clearInstagramCookies()
//        checkAndSetLoginIfNeeded()
//    }
    
    
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
    
    
   
    
    
    
    func likeButtonPressed(headerCell: PostsHeaderTableViewCell) {
        if let MediaID = headerCell.mediaItem?.idNumber {
            println(MediaID)

            // opening Insta
            let instaURLString = "instagram://media?id=\(MediaID)"
            let instaURL = NSURL(string: instaURLString)
            if UIApplication.sharedApplication().canOpenURL(instaURL!){
                println("found insta")
                UIApplication.sharedApplication().openURL(instaURL!)
            } else {
                println("no insta")
                
                
                let alertView = UIAlertController(title: "Oops Can't Support Liking", message: "You must have instagram installed to like a photo", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
                
            }

        }
    }
    
    
    
    func refreshData(notification: NSNotification){
        println("refresh data")
        checkAndSetLoginIfNeeded()
    }
    
    
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        println("camera button pressed")
        
        // check if device supports camera
        
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        println(cameraAvailable)
        
        
        
        // action sheet
        
        let optionMenu = UIAlertController(title: nil, message: "Let's Post some Moments", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Take a Picture", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("camera")
            self.captureWithCamera()
        })
        let libraryAction = UIAlertAction(title: "Choose image from library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("library")
            self.presentLibrary()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        
        if cameraAvailable{
            optionMenu.addAction(cameraAction)
        }
        
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        // increment post count to offset notifications
        DataSource.sharedInstance.postAPic()
        
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    func presentLibrary(){
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    func captureWithCamera(){
        var imgCap = UIImagePickerController()
        imgCap.delegate = self
        imgCap.sourceType = UIImagePickerControllerSourceType.Camera;
        imgCap.mediaTypes = [kUTTypeImage]
        imgCap.allowsEditing = false
        
        self.presentViewController(imgCap, animated: true, completion: nil)
    }
    
    
    
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if let imagePicked = image {
            println("image captured")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sendImageToInstagram(image)
    }
    

    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func sendImageToInstagram (image: UIImage) {
        println("send image to insta")
        
//        // increment post count to offset notifications
//        DataSource.sharedInstance.postAPic()
        
        
        
        
        // Prep image for insta
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tmpDirURL?.URLByAppendingPathComponent("blocstagram").URLByAppendingPathExtension("igo")
        let success = imageData.writeToURL(fileURL!, atomically: true)
        
        if !success{
            println("error")
            return
        }

        
        self.documentController = UIDocumentInteractionController(URL: fileURL!)
        self.documentController!.UTI = "com.instagram.exclusivegram"
        self.documentController!.delegate = self
        
        self.documentController!.presentOptionsMenuFromBarButtonItem(self.cameraButton, animated: true)
        
        
        
        
    }
    

    
    
    
    func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}
