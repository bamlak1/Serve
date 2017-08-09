//
//  CauseTableViewCell.swift
//  Serve
//
//  Created by Michael Hamlett on 7/24/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CauseTableViewCell: UITableViewCell {

    @IBOutlet weak var causeImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var pic : PFFile?
    
    var cause: PFObject! {
        didSet{
            nameLabel.text = (cause["name"] as! String)
            pic = cause["image"] as! PFFile
            causeImageView.image = nil
            pic?.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.causeImageView.image = finalImage
                }
            }
        }
    }
    
    var delegate: CauseTVCellDelegate!
    var indexPath: IndexPath!
    
    
    @IBAction func addPressed(_ sender: Any) {
        //addButton.isSelected = true
        print("cell \(indexPath)")
        self.delegate?.didclickOnCellAtIndex(at: self.indexPath)
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
