//
//  OrgEventDetailViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/17/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrgEventDetailViewController: UIViewController {

    var event: PFObject?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func signUpPressed(_ sender: Any) {
        Pending.postPending(user: PFUser.current()!, event: event!, auto: false) { (success: Bool, error: Error?) in
            if success {
                print("pending request made")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = event?["title"] as! String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
