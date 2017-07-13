//
//  CauseCell.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import AlamofireImage

class CauseCell: UICollectionViewCell {
    
    @IBOutlet weak var causeName: UILabel!
    @IBOutlet weak var causeImageView: UIImageView!
    var cause: Cause! {
        didSet {
            causeName.text = cause.name
            causeImageView.af_setImage(withURL: cause.iconUrl!)
        }
    }
    
}
