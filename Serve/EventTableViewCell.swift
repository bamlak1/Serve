//
//  EventTableViewCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse
import ParseUI

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var bannerImageView: PFImageView!
    @IBOutlet weak var numVolLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    var banner : PFFile?

    
    var event : PFObject! {
        didSet{
            bannerImageView.image = nil
            banner = (event["banner"] as! PFFile)
            banner?.getDataInBackground { (data: Data?, error: Error?) in
                if(error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.bannerImageView.image = finalImage
                }
            }
            
            descriptionLabel.text = (event["description"] as! String)
            eventNameLabel.text = (event["title"] as! String)
            
            let start = event["start"] as! String
            let end = event["end"] as! String
            dateTimeLabel.text = "\(start) - \(end)"
            let num = event["volunteers"] as! Int
            numVolLabel.text = "\(num) volunteers"
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
