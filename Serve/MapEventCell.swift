//
//  MapEventCell.swift
//  Serve
//
//  Created by Olga Andreeva on 7/17/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit

class MapEventCell: UICollectionViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBInspectable var selectionColor: CGColor! {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.layer.borderColor = selectionColor
        selectedBackgroundView = view
    }
}
