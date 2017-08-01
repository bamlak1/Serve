//
//  CustomInfoWindow.swift
//  Serve
//
//  Created by Olga Andreeva on 7/31/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

protocol RegisterButtonDelegate {
    func didPressRegister()
}

class CustomInfoWindow: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var volunteerLabel: UILabel!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var markerInfoBackground: UIImageView!
    var delegate: RegisterButtonDelegate!
    
    override func awakeFromNib() {
        register.isEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    @IBAction func tapRegister(_ sender: Any) {
        delegate.didPressRegister()
        print("yes we tapped it!")
    }
}
