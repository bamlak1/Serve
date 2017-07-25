//
//  OtherUserViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/21/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OtherUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentUser = PFUser.current()
    var followingArr : [String]?
    var userID : String?
    var user : PFUser?
    var updates : [PFObject] = []
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orgNameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrganizationViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveUser()
        setUserData()
        retrieveUpdates()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        retrieveUser()
        retrieveUpdates()
        setUserData()
    }
    
    func setUserData() {
        let type = user?["type"] as! String
        switch type {
        case "Organization":
            
            print("loading Org")
            orgNameLabel.text = user?["username"] as! String
            
            if let mission = user?["mission"] {
                missionLabel.text = (mission as! String)
            }
            
//            if let contact = user?["contact"] {
//                contactLabel.text = (contact as! String)
//            }
//            
            if let banner = user?["banner"] as? PFFile {
                banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.bannerImageView.image = finalImage
                    }
                })
            }
            
            if let userCauses = user?["causes"] as? [PFObject]{
                for index in 0...1{
                    let cause = userCauses[index]
                    let name = cause["name"] as! String
                    interestsLabel.text?.append("\(name), " )
                    
                }
                let lastCause = userCauses[2]
                let name = lastCause["name"] as! String
                interestsLabel.text?.append(name)
            }
            
            if let profileImage = user?["profile_image"] as? PFFile {
                profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.profileImageView.image = finalImage
                    }
                })
            }
            
            followingArr = (currentUser!["following"] as! [String])
            print(followingArr!)
            if (followingArr?.contains(user!.objectId!))! {
                followOutlet.isSelected = true
            }
            
            self.refreshControl.endRefreshing()
            
            
        case "Individual":
            print("loading user")
            
            if let bio = user?["bio"] {
                missionLabel.text = bio as! String
            }
            if let banner = user?["banner"] as? PFFile {
                banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.bannerImageView.image = finalImage
                    }
                })
            }
            
            if let userCauses = user?["causes"] as? [PFObject]{
                for index in 0...1{
                    let cause = userCauses[index]
                    let name = cause["name"] as! String
                    interestsLabel.text?.append("\(name), " )
                    
                }
                let lastCause = userCauses[2]
                let name = lastCause["name"] as! String
                interestsLabel.text?.append(name)
            }
            
            if let profileImage = user?["profile_image"] as? PFFile {
                profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        self.profileImageView.image = finalImage
                    }
                })
                
            }
            followingArr = (currentUser!["following"] as! [String])
            //print(followingArr!)
            if (followingArr?.contains(user!.objectId!))! {
                followOutlet.isSelected = true
            }
            
            self.refreshControl.endRefreshing()
            
        default:
            break
        }
        
        
        
        
    }
    
    
    func retrieveUpdates() {
        let query = PFQuery(className: "Post")
        query.whereKey("user", equalTo: user!)
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
        
        let update = updates[indexPath.row]
        let org = update["user"] as! PFObject
        //print(org)
        let event = update["event"] as! PFObject
        let orgName = org["username"] as! String
        let eventTitle = event["title"] as! String
        let action = update["action"] as! String
        
        if let profileImage = org["profile_image"] as? PFFile{
            profileImage.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.profilePicImageView.image = finalImage
                }
            }
        }
        
        cell.nameLabel.text = orgName
        cell.actionLabel.text = action
        cell.eventLabel.text = eventTitle
        
        return cell
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
        //print(followingArr!)
        if (followOutlet.isSelected) {
            self.currentUser!.remove(user!.objectId, forKey: "following")
            self.currentUser?.incrementKey("following_count", byAmount: -1)
            if let index = followingArr?.index(of: user!.objectId!) {
                followingArr!.remove(at: index)
            }
            
            followOutlet.isSelected = false
            currentUser!.saveInBackground()
            print("Unfollowed")
        } else {
        self.currentUser!.addUniqueObject(user?.objectId!, forKey: "following")
        self.currentUser?.incrementKey("following_count")
        followingArr?.append(user!.objectId!)
            
        followOutlet.isSelected = true
        currentUser!.saveInBackground()
        print("followed")
        }
    }
    
    func retrieveUser() {
        let query = PFUser.query()
        query?.includeKey("causes")
        do {
            try self.user = query?.getObjectWithId(self.userID!) as! PFUser
        } catch {
            print("error")
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
