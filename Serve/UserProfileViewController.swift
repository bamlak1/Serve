//
//  UserProfileViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
 
    
    var user: PFUser?
    var userPosts: [PFObject] = []
    var upcomingEvents : [PFObject] = []
    var pastEvents: [PFObject] = []
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UserProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
        profileTableView.insertSubview(refreshControl, at: 0)
        
        loadUserData()
        fetchUserUpdates()
        retrievePastEvents()
        retrieveUpcomingEvents()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        loadUserData()
        fetchUserUpdates()
        retrieveUpcomingEvents()
        retrievePastEvents()
    }

    func loadUserData() {
        user = PFUser.current()
        
        if let username = user!["username"] {
            nameLabel.text = (username as! String)
        }
        
        if let interests = user!["interests"] {
            interestsLabel.text = (interests as! String)
        }
        if let bio = user!["bio"] {
            bioLabel.text = bio as! String
        }
        if let friendsCount = user!["friendsCount"] {
            followerCountLabel.text = (friendsCount as! String)
        }
        if let followingCount = user!["followingCount"] {
            followingCountLabel.text = (followingCount as! String)
        }
        
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
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
        profilePicImageView.clipsToBounds = true;
        self.refreshControl.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        loadUserData()
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
            let username = user?["username"] as! String
            let image = user?["profile_image"] as! PFFile
            //let caption = post["caption"] as! String
            //let date = post["date"] as! String
            //let fives = post["high-fives"] as! String
            let action = post["action"] as! String
            let event = post["event"] as! PFObject

            cell.event = event
            let eventTitle = event["title"] as! String
            //let event = create event stuff
            
            
            image.getDataInBackground { (data: Data?, error: Error?) in
                if(error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.profilePicImageView.image = finalImage
                }
            }
            
            cell.nameLabel.text = username
            cell.eventLabel.text = eventTitle
            cell.actionLabel.text = action
            returnCell = cell
        case 1:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = upcomingEvents[indexPath.row]
            let image = event["banner"] as! PFFile
            let description = event["description"] as! String
            let start = event["start"] as! String
            let end = event["end"] as! String
            let title = event["title"] as! String
            
            image.getDataInBackground { (data: Data?, error: Error?) in
                if(error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.bannerImageView.image = finalImage
                }
            }
            
            cell.eventNameLabel.text = title
            cell.dateTimeLabel.text = "\(start) - \(end)"
            cell.descriptionLabel.text = description
            returnCell = cell
        case 2:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = pastEvents[indexPath.row]
            let image = event["banner"] as! PFFile
            let description = event["description"] as! String
            let start = event["start"] as! String
            let end = event["end"] as! String
            let title = event["title"] as! String
            
            image.getDataInBackground { (data: Data?, error: Error?) in
                if(error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.bannerImageView.image = finalImage
                }
            }
            
            cell.eventNameLabel.text = title
            cell.dateTimeLabel.text = "\(start) - \(end)"
            cell.descriptionLabel.text = description
            returnCell = cell
        default:
            break
        }
        
        return returnCell!
    }
    
    func fetchUserUpdates() {
        let user = PFUser.current()
        //let id = user!.objectId!
        
        
        let query = PFQuery(className: "Post")
        query.whereKey("user", equalTo: user!)
        query.includeKey("event")
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
        let user = PFUser.current()
        
        let date = Date()
        
        let query = PFQuery(className: "Event")
        query.whereKey("accepted_users", equalTo: user)
        query.whereKey("start_date", lessThan: date)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.pastEvents = events!
                self.profileTableView.reloadData()
                self.refreshControl.endRefreshing()
                print(self.pastEvents)
                print("Loaded past events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    func retrieveUpcomingEvents() {
        let user = PFUser.current()
        
        let date = Date()
        
        let query = PFQuery(className: "Event")
        query.whereKey("accepted_users", equalTo: user)
        query.whereKey("start_date", greaterThan: date)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.upcomingEvents = events!
                self.profileTableView.reloadData()
                print("Loaded upcoming events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
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
