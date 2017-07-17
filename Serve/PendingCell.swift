//
//  PendingCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class PendingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBAction func yesPressed(_ sender: Any) {
        
    }
    
  
    @IBAction func noPressed(_ sender: Any) {
        
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
