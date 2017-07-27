//
//  UserProfileViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var bannerImageView: PFImageView!
    @IBOutlet weak var profilePicImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
 
    var user : PFUser?
    var userType: String?
    var currentUser = PFUser.current()
    var userPosts: [PFObject] = []
    var upcomingEvents : [PFObject] = []
    var pastEvents: [PFObject] = []
    var followingArr : [String]?
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UserProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
        profileTableView.insertSubview(refreshControl, at: 0)
        
        setUser()
        fetchUserUpdates()
        retrievePastEvents()
        retrieveUpcomingEvents()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        setUser()
        fetchUserUpdates()
        retrieveUpcomingEvents()
        retrievePastEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        fetchUserUpdates()
        retrievePastEvents()
        retrieveUpcomingEvents()

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.profileTableView.rowHeight = 73
            return userPosts.count
        case 1:
            self.profileTableView.rowHeight = 291
            return upcomingEvents.count
        case 2:
            self.profileTableView.rowHeight = 291
            return pastEvents.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell: UITableViewCell?
        
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            let post = userPosts[indexPath.row]
            let user = post["user"] as! PFUser
            let event = post["event"] as! PFObject
            cell.indexPath = indexPath
            cell.user = user
            cell.event = event
            cell.post = post
            
            returnCell = cell
        case 1:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = upcomingEvents[indexPath.row]
            cell.event = event
            returnCell = cell
        case 2:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = pastEvents[indexPath.row]
            cell.event = event
            returnCell = cell
        default:
            break
        }
        
        return returnCell!
    }
    
    func fetchUserUpdates() {
        
        let query = PFQuery(className: "Post")
        query.whereKey("user", equalTo: user!)
        query.includeKey("event")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        
        query.limit = 10
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.userPosts = posts!
                self.profileTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
    }
    
    func retrievePastEvents() {
        
        let date = Date()
        
        let query = PFQuery(className: "Event")
        if userType == "Individual" {
            query.whereKey("accepted_ids" , equalTo: (user?.objectId)!)
        } else {
            query.whereKey("author", equalTo: user!)
        }
        query.whereKey("start_date", lessThan: date)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.pastEvents = events!
                self.profileTableView.reloadData()
                self.refreshControl.endRefreshing()
                //print(self.pastEvents)
                //print("Loaded past events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    func retrieveUpcomingEvents() {

        let date = Date()
        
        let query = PFQuery(className: "Event")
        if userType == "Individual" {
            query.whereKey("accepted_ids" , equalTo: (user?.objectId)!)
        } else {
            query.whereKey("author", equalTo: user!)
        }
        query.whereKey("start_date", greaterThan: date)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.upcomingEvents = events!
                self.profileTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    func setUser() {

        if user == nil {
            user = PFUser.current()!
        }
        
        let type = user!["type"] as! String
        userType = type
        
        if let causes = user?["cause_names"] as? [String] {
            for index in 0...1{
                let name = causes[index]
                interestsLabel.text?.append("\(name), " )
                
            }
            let name2 = causes[2]
            interestsLabel.text?.append(name2)
        }

        
        if let username = user!["username"] {
            nameLabel.text = (username as! String)
        }
         if let bio = user!["bio"] {
            bioLabel.text = (bio as! String)
        }
        if let friendsCount = user!["friendsCount"] {
            followerCountLabel.text = (friendsCount as! String)
        }
        if let followingCount = user!["followingCount"] {
            followingCountLabel.text = (followingCount as! String)
        }
        
        bannerImageView.image = nil
        if let banner = user!["banner"] as? PFFile {
            banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.bannerImageView.image = finalImage
                }
            })
        }
        
        profilePicImageView.image = nil
        if let profileImage = user!["profile_image"] as? PFFile {
            profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.profilePicImageView.image = finalImage
                }
            })
        }
        
        if user?.objectId == PFUser.current()?.objectId {
            print("on current user's page")
            editButton.isEnabled = true
            editButton.isHidden = false
            followButton.isEnabled = false
            followButton.isHidden = true
        } else if user?.objectId != PFUser.current()?.objectId {
            print("on other user's page")
            followButton.isEnabled = true
            followButton.isHidden = false
            editButton.isEnabled = false
            editButton.isHidden = true
        }
        
        if followButton.isEnabled && currentUser!["following"] != nil{
            followingArr = (currentUser!["following"] as! [String])
            //print(followingArr!)
            if (followingArr?.contains(user!.objectId!))! {
                followButton.isSelected = true
            }
        }
        
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
        profilePicImageView.clipsToBounds = true;
        self.refreshControl.endRefreshing()
    }

    
    @IBAction func followPressed(_ sender: Any) {
        //print(followingArr!)
        if (followButton.isSelected) {
            self.currentUser!.remove(user!.objectId!, forKey: "following")
            self.currentUser?.incrementKey("following_count", byAmount: -1)
            if let index = followingArr?.index(of: user!.objectId!) {
                followingArr!.remove(at: index)
            }
            
            followButton.isSelected = false
            currentUser!.saveInBackground()
            print("Unfollowed")
        } else {
            self.currentUser!.addUniqueObject(user?.objectId!, forKey: "following")
            self.currentUser?.incrementKey("following_count")
            followingArr?.append(user!.objectId!)
            
            followButton.isSelected = true
            currentUser!.saveInBackground()
            print("followed")
        }
    }

    
    


  
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if segue.identifier == "event"{
            let button = sender as! UIButton
            let indexPath = button.tag
            let update = userPosts[indexPath]
            let event = update["event"] as! PFObject
            
            let vc = segue.destination as! EventDetailViewController
            vc.event = event
        } else if segue.identifier == "eventCell" {
            let cell = sender as! EventTableViewCell
            let vc = segue.destination as! EventDetailViewController
            vc.event = cell.event
        }
     }
    
    
}
