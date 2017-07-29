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
            commentButton.tag = indexPath.row
        }
    }

    @IBOutlet weak var eventButtonOutlet: UIButton!

    @IBOutlet weak var nameButtonOutlet: UIButton!
    
    @IBOutlet weak var fiveButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var fiveCountLabel: UILabel!

    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post : PFObject! {
        didSet{
            nameLabel.text = (user!["username"] as! String)
            if event != nil {
                eventLabel.text = (event!["title"] as! String)
            }
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
            if post["high-fives"] != nil {
                fiveCountLabel.text = post["high-fives"] as? String
            }
            if event == nil {
                eventButtonOutlet.isEnabled = false
            }
        }
        
     
    }
   
    
    
    @IBAction func ddiPressFive(_ sender: Any) {
        //find way to reference high fives
        if fiveButton.isSelected == false {
            post["fived"] = true
            fiveButton.isSelected = post["fived"]! as! Bool
            self.post.incrementKey("high_fives")
            fiveCountLabel.text = post["high_fives"] as? String
            print(post["high_fives"] as? String! ?? nil)
            
        
        }
            
            
        else if fiveButton.isSelected == true {
            post["fived"] = false
            fiveButton.isSelected = post["fived"]! as! Bool
            self.post.incrementKey("high_fives")
            fiveCountLabel.text = post["high_fives"] as? String
            print(post["high_fives"] as? String! ?? nil)
            
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
