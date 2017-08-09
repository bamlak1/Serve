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
    var eventId: String?
    var org : PFUser?
    var accepts : [String] = []
    var pendings : [String] = []
    var past : Bool = false
    
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
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        let query = PFQuery(className: "Event")
        query.whereKey("objectId", equalTo: eventId!)
        query.includeKey("author")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let event = events?.first {
                self.event = event
                self.org = event["author"] as! PFUser
                if let accepts = event["accepted_ids"] as? [String] {
                    self.accepts = accepts
                }
                if let pendings = event["pending_ids"] as? [String] {
                    self.pendings = pendings
                    print(self.pendings)
                }
                if self.accepts.contains((PFUser.current()!.objectId)!) || self.pendings.contains((PFUser.current()!.objectId)!) {
                    self.signUpButton.isSelected = true
                }
                
                if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                    let viewController = navController.viewControllers[navController.viewControllers.count - 2]
                    if !(viewController is MapViewController) {
                        self.dismissButton.isHidden = true
                    }
                }
                
                self.signUpButton.setTitle("Signed up", for: .selected)
                self.titleLabel.text = event["title"] as? String
                if event["org_name"] != nil {
                    self.orgLabel.text = (event["org_name"] as! String)
                }
                let start = event["start"] as! String
                let end = event["end"] as! String
                let prefix = String(start.characters.prefix(10))
                if end.hasPrefix(prefix) {
                    let suffixIndex = end.index(end.endIndex, offsetBy: -9)
                    let newEnd = end.substring(from: suffixIndex)
                    self.dateLabel.text = "\(start) - \(newEnd)"
                } else {
                    self.dateLabel.text = "\(start) - \(end)"
                }
                self.locationLabel.text = (event["location"] as! String)
                self.descriptionLabel.text = (event["description"] as! String)
                let volunteerCount = event["volunteers"] as? Int ?? 0
                self.volunteerLabel.text = "\(volunteerCount) volunteers"
                self.expectedTasksLabel.text = (event["expected_tasks"] as! String)
                
                
                let image = event["banner"] as! PFFile
                self.bannerImageView.image = nil
                image.getDataInBackground { (data: Data?, error: Error?) in
                    if(error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.bannerImageView.image = finalImage
                    }
                }
                
                if self.past {
                    self.performSegue(withIdentifier: "compose", sender: self)
                }
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
            UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
            vc.delegate = self
            vc.event = self.event
            if past{
                vc.reflection = true
            }else {
                vc.reflection = false
            }
            
        } else if segue.identifier == "org"{
            let vc = segue.destination as! UserProfileViewController
            vc.user = org
        }
     }
    
    
    
}
