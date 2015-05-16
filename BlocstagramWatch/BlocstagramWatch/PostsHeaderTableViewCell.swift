//
//  PostsHeaderTableViewCell.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit


protocol PostsHeaderTableViewCellDelegate {
    func likeButtonPressed (headerCell: PostsHeaderTableViewCell)
}




class PostsHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var likesButtonCounter: UIView!
//    @IBOutlet var likeButton: UIImageView!
    @IBOutlet var likesCount: UILabel!
    @IBOutlet var likeButton: UIButton!
    var mediaItem: Media?
    var delegate: PostsHeaderTableViewCellDelegate?
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setMedia(mediaItem: Media){
        
        resetCell()
        
        let imageView = self.profileImage as UIImageView
        let url = mediaItem.user?.profilePictureURL
        imageView.hnk_setImageFromURL(url!)
    
        if mediaItem.likeState! {
//            self.likeButton.image = UIImage(named: "heart-full")
            self.likeButton.setImage(UIImage(named: "heart-full"), forState: UIControlState.Normal)
        } else {
//            self.likeButton.image = UIImage(named: "heart-empty")
            self.likeButton.setImage(UIImage(named: "heart-empty"), forState: UIControlState.Normal)
        }
        
        self.usernameLabel.text = mediaItem.user?.userName as? String
        
        if let tempCount = mediaItem.likesCount {
            self.likesCount.text = String(tempCount)
        }
        
        self.mediaItem = mediaItem
    }

    
    func resetCell(){
        self.profileImage.image = UIImage(named: "TestImage.JPG")
        self.usernameLabel.text = ""
//        self.likeButton.image = UIImage(named: "heart-empty")
        self.likesCount.text = ""
        self.likeButton.setImage(UIImage(named: "heart-empty"), forState: UIControlState.Normal)
        
    }

    
    
    @IBAction func likeButtonPressed(sender: UIButton) {
        println("like button pressed")
        

        // delegate
        if let delegate = self.delegate {
            delegate.likeButtonPressed(self)
        }
        
        
//        
//        
//        let testMediaID = self.mediaItem!.idNumber as! String
//        
//        // testing that data coming through
//        println(testMediaID)
//        println(DataSource.sharedInstance.accessToken)
//        
//        let instaURLString = "instagram://media?id=\(testMediaID)"
//        let instaURL = NSURL(string: instaURLString)
//        if UIApplication.sharedApplication().canOpenURL(instaURL!){
//            println("found insta")
//            UIApplication.sharedApplication().openURL(instaURL!)
//        } else {
//            println("no insta")
//        }

        
    }
    
    
    
}
