//
//  IndividualLoginViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class IndividualLoginViewController: UIViewController {
    
    @IBOutlet weak var addressInfoView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func didPressInfoAddress(_ sender: Any) {
        addressInfoView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressInfoView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBackground(_ sender: Any) {
        addressInfoView.isHidden = true
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
