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
    
    @IBOutlet weak var mainBackground: UIView!
    
    var delegate : PostCellDelegate!
    var event : PFObject?
    var user: PFUser?
    var userType: String?
    var pic : PFFile?
    var bannerPic: PFFile?
    var indexPath : IndexPath!{
        didSet{
            nameButtonOutlet.tag = indexPath.row
            eventButtonOutlet.tag = indexPath.row
            commentButton.tag = indexPath.row
        }
    }
    
    @IBOutlet weak var topStackConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var eventImageViewer: UIImageView!

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
            if let date = (post["date"] as? String) {
                dateLabel.text = date
            }
            userType = (user!["type"] as! String)
            if let pic = (user!["profile_image"] as? PFFile) {
                profilePicImageView.image = nil
                
                if userType == "Individual" {
                    profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
                    profilePicImageView.clipsToBounds = true;
                }
                
            if userType == "Organization" {
                eventImageViewer.isHidden = false
                topStackConstraint.constant = 148
                if event != nil {
                    bannerPic = (event?["banner"] as! PFFile)
                }
                eventImageViewer.image = nil
                bannerPic?.getDataInBackground { (data: Data?, error: Error?) in
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.eventImageViewer.image = finalImage
                    }
                }
            } else {
                eventImageViewer.isHidden = true

                topStackConstraint.constant = 8

                
            
            }
            pic.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.profilePicImageView.image = finalImage
                }
            }
            
            if post["caption"] != nil {
                captionLabel.text = (post["caption"] as! String)
            } else {
                captionLabel.text = ""
            }
            if post["high_fives"] != nil{
                let fives = post["high_fives"]
                fiveCountLabel.text = "\(fives ?? 3)"
            }
            if event == nil {
                eventButtonOutlet.isEnabled = false
            }
        }
        
        }
    }
  
    
    @IBAction func didPressFive(_ sender: Any) {
        //find way to reference high fives
        if fiveButton.isSelected == false {
            post["fived"] = true
            fiveButton.isSelected = post["fived"]! as! Bool
            self.post.incrementKey("high_fives")
            let fives = post["high_fives"]
            fiveCountLabel.text = "\(fives ?? 1)"
            print(post["high_fives"])
            
            post?.saveInBackground(block: { (success: Bool, error: Error?) in
            })
            
        } else if fiveButton.isSelected == true {
            post["fived"] = false
            fiveButton.isSelected = post["fived"]! as! Bool
            self.post.incrementKey("high_fives", byAmount: -1)
            let fives = post["high_fives"]
            fiveCountLabel.text = "\(fives ?? 0)"
            print(post["high_fives"])
            
            post?.saveInBackground(block: { (success: Bool, error: Error?) in
                // TODO: add alerts
            })
            
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
