//
//  PendingCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class PendingCell: UITableViewCell {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    
    var event : PFObject!
    var user : PFUser!
    var request : PFObject!
    
    @IBAction func yesPressed(_ sender: Any) {
        event.addUniqueObject(user, forKey: "accepted_users")
        user.addUniqueObject(event, forKey: "accepted_events")
        request["completed"] = true
        
        event.saveInBackground()
        user.saveInBackground()
        request.saveInBackground()
        
        print("accepted")
    }
    
  
    @IBAction func noPressed(_ sender: Any) {
        
        event.remove(user, forKey: "pending_users")
        user.remove(event, forKey: "pending_events")
        request["completed"] = true
        
        event.saveInBackground()
        user.saveInBackground()
        request.saveInBackground()
        
        print("denied")
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
