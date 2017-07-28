//
//  PostCell.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Parse
import ParseUI


class PostCell: UITableViewCell {

    @IBOutlet weak var linkLabel: TTTAttributedLabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: PFImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate : PostCellDelegate!
    var event : PFObject?
    var user: PFUser?
    var userType: String?
    var pic : PFFile?
    var indexPath : IndexPath!{
        didSet{
            nameButtonOutlet.tag = indexPath.row
            eventButtonOutlet.tag = indexPath.row
            //commentButton.tag = indexPath.row
        }
    }

    @IBOutlet weak var eventButtonOutlet: UIButton!

    @IBOutlet weak var nameButtonOutlet: UIButton!
    
    @IBOutlet weak var fiveButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    

//    @IBAction func namePressed(_ sender: Any) {
//        let user = self.user!
//        let type = user["type"] as! String
//        print("functional")
//        
//        if(self.delegate != nil ) {
//            self.delegate.callSegueFromCell(myData: user, type: type)
//        }
//    }
    
    var post : PFObject! {
        didSet{
            nameLabel.text = (user!["username"] as! String)
            eventLabel.text = (event!["title"] as! String)
            actionLabel.text = (post["action"] as! String)
            userType = (user!["type"] as! String)
            pic = (user!["profile_image"] as! PFFile)
            profilePicImageView.image = nil
            pic?.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.profilePicImageView.image = finalImage
                }
            }
            if post["caption"] != nil {
                captionLabel.text = (post["caption"] as! String)
            }
        }
    }
   
        

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
