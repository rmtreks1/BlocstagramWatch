//
//  PostsTableViewCell.swift
//  BlocstagramWatch
//
//  Created by Roshan Mahanama on 13/05/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postComments: UILabel!
    @IBOutlet var postCaption: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setMedia(mediaItem: Media){
        
        let imageView = self.postImage
        let url = mediaItem.mediaURL
        imageView.hnk_setImageFromURL(url!)
        
        self.postCaption.text = mediaItem.caption as? String
        
        if mediaItem.comments.count > 0 {
            self.postComments.text = mediaItem.comments[0].text as? String
        }
    }
    
    

}
