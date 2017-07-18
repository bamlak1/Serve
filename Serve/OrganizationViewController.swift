//
//  OrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrganizationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let user = PFUser.current()!
    var updates : [PFObject] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var numHelpedLabel: UILabel!
    @IBOutlet weak var numVolLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveOrgData()
        retrieveOrgUpdates()

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

    
    func retrieveOrgUpdates() {
        let query = PFQuery(className: "Post")
        query.whereKey("org", equalTo: user)
        query.includeKey("org")
        query.includeKey("event")
        
        
        query.findObjectsInBackground { (updates: [PFObject]?, error: Error?) in
            if let updates = updates {
                self.updates = updates
                self.tableView.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = updates[indexPath.row]
        let org = update["org"] as! PFObject
        print(org)
        let event = update["event"] as! PFObject
        let orgName = org["username"] as! String
        let eventTitle = event["title"] as! String
        let action = update["action"] as! String
        
        cell.nameLabel.text = orgName
        cell.actionLabel.text = action
        cell.eventLabel.text = eventTitle
        
        return cell
        
        
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
