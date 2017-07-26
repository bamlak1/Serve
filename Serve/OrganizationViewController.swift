//
//  OrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrganizationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var user = PFUser.current()
    var updates : [PFObject] = []
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var numHelpedLabel: UILabel!
    @IBOutlet weak var numVolLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var causesLabel: UILabel!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrganizationViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setOrgData()
        retrieveOrgUpdates()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        retrieveOrgUpdates()
        setOrgData()
    }
    
    func setOrgData() {
        orgNameLabel.text = (user!["username"] as! String)
        
        if let mission = user!["mission"] {
            missionLabel.text = (mission as! String)
        }
        
        if let contact = user!["contact"] {
            contactLabel.text = (contact as! String)
        }
        
        if let causes = user!["cause_names"] as? [String] {
            for index in 0...1{
                let name = causes[index]
                causesLabel.text?.append("\(name), " )
                
            }
            let name = causes[2]
            causesLabel.text?.append(name)
        }
        
        if user!["banner"] != nil {
            let banner = user!["banner"] as! PFFile
            banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.bannerImageView.image = finalImage
                }
            })
        }
        
        if let profileImage = user!["profile_image"] as? PFFile {
            profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.profileImageView.image = finalImage
                }
            })
        }
        self.refreshControl.endRefreshing()
        
    }



    func retrieveOrgUpdates() {
        let query = PFQuery(className: "Post")
        query.whereKey("user", equalTo: user)
        query.includeKey("user")
        query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (updates: [PFObject]?, error: Error?) in
            if let updates = updates {
                self.updates = updates
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = updates[indexPath.row]
        let user = post["user"] as! PFUser
        let event = post["event"] as! PFObject
        cell.user = user
        cell.event = event
        cell.post = post
        
        
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
