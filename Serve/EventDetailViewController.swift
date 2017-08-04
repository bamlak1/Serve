//
//  EventDetailViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventDetailViewController: UIViewController, NotifyEventDelegate{
    
    var event: PFObject?
    var org : PFUser?
    var accepts : [String] = []
    var pendings : [String] = []
    
    @IBOutlet weak var bannerImageView: PFImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var volunteerLabel: UILabel!
    @IBOutlet weak var expectedTasksLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let accepts = event?["accepted_ids"] as? [String] {
            self.accepts = accepts
        }
        if let pendings = event?["pending_ids"] as? [String] {
            self.pendings = pendings
            print(self.pendings)
        }
        if accepts.contains((PFUser.current()!.objectId)!) || pendings.contains((PFUser.current()!.objectId)!) {
            signUpButton.isSelected = true
        }
        
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            let viewController = navController.viewControllers[navController.viewControllers.count - 2]
            if !(viewController is MapViewController) {
                dismissButton.isHidden = true
            }
        }

        signUpButton.setTitle("Signed up", for: .selected)
        titleLabel.text = event?["title"] as? String
        if event?["org_name"] != nil {
            orgLabel.text = (event?["org_name"] as! String)
        }
        let start = event?["start"] as! String
        let end = event?["end"] as! String
        dateLabel.text = "\(start) - \(end)"
        locationLabel.text = (event?["location"] as! String)
        descriptionLabel.text = (event?["description"] as! String)
        let volunteerCount = event?["volunteers"] as? Int ?? 0
        volunteerLabel.text = "\(volunteerCount) volunteers"
        expectedTasksLabel.text = (event?["expected_tasks"] as! String)
        
        
        let image = event?["banner"] as! PFFile
        bannerImageView.image = nil
        image.getDataInBackground { (data: Data?, error: Error?) in
            if(error != nil) {
                print(error?.localizedDescription ?? "error")
            } else {
                let finalImage = UIImage(data: data!)
                self.bannerImageView.image = finalImage
            }
        }
        
    }
    
    func didPressSignUp() {
        signUpButton.isSelected = true
        signUpButton.setTitle("Signed up", for: .selected)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "accepted" {
            let vc = segue.destination as! AcceptedUsersViewController
            vc.event = self.event
            
        } else if segue.identifier == "compose"{
            let vc = segue.destination as! ComposeUpdateViewController
            
            vc.delegate = self
            vc.event = self.event
        } else if segue.identifier == "org"{
            let vc = segue.destination as! UserProfileViewController
            vc.user = org
        }
     }
    
    
    
}
