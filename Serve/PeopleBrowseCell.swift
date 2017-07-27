//
//  PeopleBrowseCell.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PeopleBrowseCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    var pic : PFFile?
    @IBOutlet weak var imageViewer: PFImageView!
    
    @IBOutlet weak var button: UIButton!
    
    var indexPath : IndexPath! {
        didSet{
            button.tag = indexPath.item
        }
    }
    var user : PFUser! {
        didSet{
            nameLabel.text = (user["username"] as! String)
            pic = user["profile_image"] as? PFFile
            imageViewer.image = nil
            pic?.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.imageViewer.image = finalImage
                }
            })
            
        }
    }
    
    
    
    
}
