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
    
    var pic : PFFile?
    var delegate : PendingCellDelegate!
    var indexPath: IndexPath!
    
    var event : PFObject!
    var user : PFUser!
    var request : PFObject! {
        didSet{
            
            nameLabel.text = (user["username"] as! String)
            eventTitle.text = (request["event_name"] as! String)
            
            if user!["profile_image"] != nil {
                pic = (user!["profile_image"] as! PFFile)
                pic?.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.profileImageView.image = finalImage
                    }
                })
                
            }
        }
    }
    @IBAction func namePressed(_ sender: Any) {
       
    }
    
    @IBAction func eventPressed(_ sender: Any) {
        
        
    }
    
    
    @IBAction func yesPressed(_ sender: Any) {
        event.remove(user, forKey: "pending_users")
        event.addUniqueObject(user, forKey: "accepted_users")
        event.incrementKey("volunteers")
        request["completed"] = true
        
        event.saveInBackground()
        request.saveInBackground()
        
        self.delegate?.didclickOnCellAtIndex(at: indexPath)
        
        print("accepted")
    }
    
  
    @IBAction func noPressed(_ sender: Any) {
        
        event.remove(user, forKey: "pending_users")
        request["completed"] = true
        
        event.saveInBackground()
        request.saveInBackground()
        
        self.delegate?.didclickOnCellAtIndex(at: indexPath)
        
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
