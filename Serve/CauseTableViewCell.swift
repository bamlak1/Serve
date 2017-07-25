//
//  CauseTableViewCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/24/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class CauseTableViewCell: UITableViewCell {

    @IBOutlet weak var causeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var cause: PFObject?
    
    var delegate: CauseTVCellDelegate!
    var indexPath: IndexPath!
    
    
    @IBAction func addPressed(_ sender: Any) {
        addButton.isSelected = true
        self.delegate?.didclickOnCellAtIndex(at: indexPath)
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
