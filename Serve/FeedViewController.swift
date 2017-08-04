//
//  FeedViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

protocol PostCellDelegate{
    func callSegueFromCell(myData user: Any, type: String)
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    
    var isMoreDataLoading = false
    var currentUser = PFUser.current()
    var updates: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    

    @IBOutlet var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        feedTableView.insertSubview(refreshControl, at: 0)
        
        fetchUpdates()
        
    }
    

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchUpdates()
    }

    
    func fetchUpdates() {
        //make case for when someone isn't following anyone
        var following = currentUser!["following"] as! [String]
        let id = (currentUser?.objectId)!
        following.append(id)
    
        
        let query = PFQuery(className: "Post")
        query.whereKey("user_id", containedIn: following)
        query.includeKey("user")
        query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (updates: [PFObject]?, error: Error?) in
            if let updates = updates {
                self.updates = updates
                print("Loaded updates")
                self.feedTableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = updates[indexPath.row]
        let user = update["user"] as? PFUser
        let fivesCount = (update["high_fives"] as! NSNumber)
        cell.fiveCountLabel.text = "\(fivesCount)"
        if let event = update["event"] as? PFObject {
            cell.event = event
        }
        cell.indexPath = indexPath
        cell.user = user
        
        cell.post = update
        
        cell.mainBackground.layer.cornerRadius = 20
        cell.mainBackground.layer.masksToBounds = true
        
        
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        


        
        if segue.identifier == "comments"{
            let button = sender as! UIButton
            let indexPath = button.tag
            let update = updates[indexPath] 
            let user = update["user"] as! PFUser
            let event = update["event"] as! PFObject
            
             
            
            let vc = segue.destination as! PostDetailViewController
            vc.post = update
            vc.user = user
            vc.event = event
        }

        if segue.identifier == "other" {
            let button = sender as! UIButton
            let indexPath = button.tag
            let update = updates[indexPath]
            let user = update["user"] as! PFUser
            //let id = user.objectId!
            
            
            let vc = segue.destination as! UserProfileViewController
            vc.user = user
        }
        
        if segue.identifier == "event"{
            let button = sender as! UIButton
            let indexPath = button.tag
            let update = updates[indexPath]
            let event = update["event"] as! PFObject
            
            let vc = segue.destination as! EventDetailViewController
            vc.event = event
        }
    }
}
