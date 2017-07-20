//
//  UserProfileViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var user: PFUser?
    //var followingCount: Int = 0
    //var friendsCount: Int = 0
    var userPosts: [PFObject] = []
    var userPastPosts: [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        
        
        loadUserData()
    }
    

    func loadUserData() {
        user = PFUser.current()
        
        if let username = user!["username"] {
            nameLabel.text = (username as! String)
        }
        
        if let interests = user!["interests"] {
            interestsLabel.text = (interests as! String)
        }
        if let friendsCount = user!["friendsCount"] {
            friendsCountLabel.text = (friendsCount as! String)
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

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        loadUserData()
    }
    
    
    @IBAction func didPressEditProfile(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return userPosts.count
        case 1:
            return userPastPosts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! PostCell
        
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let post = userPosts[indexPath.row]
            let username = user?["username"] as! String
            let image = post["media"] as! PFFile
            let caption = post["caption"] as! String
            let date = post["date"] as! String
            let fives = post["high-fives"] as! String
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
            cell.dateLabel.text = date
            cell.linkLabel.text = caption
        //cell.eventLabel.text = event
        case 1:
            let post = userPastPosts[indexPath.row]
            let username = user?["username"] as! String
            let image = post["media"] as! PFFile
            let caption = post["caption"] as! String
            let date = post["date"] as! String
            let fives = post["high-fives"] as! String
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
            cell.dateLabel.text = date
            cell.linkLabel.text = caption
        //cell.eventLabel.text = event
        default:
            break
        }
        
        return cell
    }
    
    func fetchUserUpdates() {
        let user = PFUser.current()
        let id = user!.objectId!
        
        
        let query = PFQuery(className: "Post")
        query.whereKey("authorId", equalTo: id)
        query.whereKey("completed", equalTo: false)
        //TODO: Sort by having closest event at the top
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.userPosts = posts!
                self.profileTableView.reloadData()
                //print("posts for upcoming events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        profileTableView.reloadData()
    }
    
    func fetchPastUserUpdates() {
        let user = PFUser.current()
        let id = user!.objectId!
        
        
        let query = PFQuery(className: "Post")
        query.whereKey("authorId", equalTo: id)
        query.whereKey("completed", equalTo: true)
        //TODO: Sort by having closest event at the top
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.userPosts = posts!
                self.profileTableView.reloadData()
                //print("posts for past events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        profileTableView.reloadData()
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
