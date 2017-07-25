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


class PostCell: UITableViewCell {

    @IBOutlet weak var linkLabel: TTTAttributedLabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate : PostCellDelegate!
    var event : PFObject?
    var user: PFUser?
    var userType: String?

    @IBOutlet weak var eventButtonOutlet: UIButton!

    @IBOutlet weak var nameButtonOutlet: UIButton!
    

    @IBAction func namePressed(_ sender: Any) {
        let user = self.user!
        let type = user["type"] as! String
        
        if(self.delegate != nil ) {
            self.delegate.callSegueFromCell(myData: user, type: type)
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
