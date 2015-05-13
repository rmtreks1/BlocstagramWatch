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
    @IBOutlet var likesButton: UIView!
    @IBOutlet var usernameLabel: UILabel?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
