//
//  PostCommentCell.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/27/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell {

    @IBOutlet weak var imageViewer: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
