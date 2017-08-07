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
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = self.isSelected ? UIColor(red:0.47, green:0.83, blue:0.48, alpha:1.0).cgColor : UIColor.black.cgColor
        }
    }
}
