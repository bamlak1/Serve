
//
//  CauseCell.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import AlamofireImage
import Parse
import ParseUI
class CauseCell: UICollectionViewCell {
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var imageViewer: PFImageView!
    var pic : PFFile?
    @IBOutlet weak var button: UIButton!
    
    var indexPath: IndexPath?{
        didSet{
            button.tag = (indexPath?.item)!
        }
    }
    
    var cause: PFObject! {
        didSet{
            causeLabel.text = cause["name"] as? String
            pic = cause["image"] as? PFFile
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
