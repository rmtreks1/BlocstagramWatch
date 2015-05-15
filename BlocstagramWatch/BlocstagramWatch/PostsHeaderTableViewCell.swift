//
//  PostsHeaderTableViewCell.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class PostsHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var likesButtonCounter: UIView!
    @IBOutlet var likeButton: UIImageView!
    @IBOutlet var likesCount: UILabel!
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setMedia(mediaItem: Media){
        
        let imageView = self.profileImage as UIImageView
        let url = mediaItem.user?.profilePictureURL
        imageView.hnk_setImageFromURL(url!)
    
        if mediaItem.likeState! {
            self.likeButton.image = UIImage(named: "heart-full")
        } else {
            self.likeButton.image = UIImage(named: "heart-empty")
        }
        
        self.usernameLabel.text = mediaItem.user?.userName as? String
        
        if let tempCount = mediaItem.likesCount {
            self.likesCount.text = String(tempCount)
        }
    }

    
    
}
