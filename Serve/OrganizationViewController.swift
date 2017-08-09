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
    var follows : PFObject?
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!

    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var causesLabel: UILabel!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
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

        
        causesLabel.text = ""

        if let causes = user!["cause_names"] as? [String] {
            if causes.count > 1 {
            for index in 0...1{
                let name = causes[index]
                causesLabel.text?.append("\(name), " )
            }
        }
            if causes.count > 2 {
                let name = causes[2]
                causesLabel.text?.append(name)
            }

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
        
        let query2 = PFQuery(className: "Follow")
        query2.whereKey("owner", equalTo: (user!.objectId)!)
        query2.findObjectsInBackground { (follows: [PFObject]?, error: Error?) in
            if follows != nil {
                self.follows = follows?.first
                let count = self.follows?["count"] as! Int
                self.followerCountLabel.text = "\(count) followers"
            } else {
                print(error?.localizedDescription ?? "error loading data")
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
        if let event = post["event"] as? PFObject {
            cell.event = event
        }
        cell.user = user
        
        cell.post = post
        
        
        return cell
        
        
    }
    
    @IBAction func pushPrssed(_ sender: Any) {
        PFCloud.callFunction(inBackground: "send", withParameters: ["alertDate" : "2017-08-03T17:30:00.000Z"]) { (object: Any?, error: Error?) in
            guard error == nil else {
                print("error")
                return
            }
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
