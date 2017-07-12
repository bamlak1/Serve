//
//  OrganizationLoginViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrganizationLoginViewController: UIViewController {

    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var organizationPhone: UITextField!
    @IBOutlet weak var organizationAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setProperties(_ sender: Any) {
        let organization = PFUser.current()!
        organization["name"] = organizationName.text
        organization["phone"] = organizationPhone.text
        organization["address"] = organizationAddress.text
        organization.saveInBackground()
    }
    
    @IBAction func didPressView(_ sender: Any) {
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
