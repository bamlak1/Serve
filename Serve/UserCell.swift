//
//  UserCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/26/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class UserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aviImageView: UIImageView!
    
    var pic : PFFile?
    
    var indexPath : IndexPath!{
        didSet{
            
        }
    }
    
    var user: PFUser!{
        didSet{
            nameLabel.text = (user!["username"] as! String)
            if user!["profile_image"] != nil {
                pic = (user!["profile_image"] as! PFFile)
                aviImageView.image = nil
                pic?.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.aviImageView.image = finalImage
                    }
                })
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
