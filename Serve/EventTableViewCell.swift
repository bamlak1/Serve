//
//  EventTableViewCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var numVolLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
