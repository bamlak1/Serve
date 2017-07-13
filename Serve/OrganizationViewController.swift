//
//  OrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrganizationViewController: UIViewController {
    
    let user = PFUser.current()!
    
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var numHelpedLabel: UILabel!
    @IBOutlet weak var numVolLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveOrgData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func retrieveOrgData() {
        orgNameLabel.text = (user["username"] as! String)
        
        if let mission = user["mission"] {
            missionLabel.text = (mission as! String)
        }
        
        if let contact = user["contact"] {
            contactLabel.text = (contact as! String)
        }
        
        if let banner = user["banner"] as? PFFile {
            banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.bannerImageView.image = finalImage
                }
            })
        }
        
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
