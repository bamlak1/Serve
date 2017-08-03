//
//  PostCommentCell.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/27/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class PostCommentCell: UITableViewCell {

    @IBOutlet weak var imageViewer: PFImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: PFUser?
    var post: PFObject?
    var userType: String?
    var pic: PFFile?
    
//    var comment: PFObject! {
//        didSet{
//            nameLabel.text = (user!["username"] as! String)
//            //associatedPost = post
//            userType = (user!["type"] as! String)
//            pic = (user!["profile_image"] as! PFFile)
//            imageViewer.image = nil
//            if userType == "Individual" {
//                imageViewer.layer.cornerRadius = imageViewer.frame.size.width / 2;
//                imageViewer.clipsToBounds = true;
//            }
//            pic?.getDataInBackground { (data: Data?, error: Error?) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "error")
//                } else {
//                    let finalImage = UIImage(data: data!)
//                    self.imageViewer.image = finalImage
//                }
//            }
//            if comment["caption"] != nil {
//                commentLabel.text = (comment["caption"] as! String)
//            } else {
//                commentLabel.text = ""
//            }
//        }
//    
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
