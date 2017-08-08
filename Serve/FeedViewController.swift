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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, HighFiveDelegate {

    
    var isMoreDataLoading = false
    var currentUser = PFUser.current()
    var updates: [PFObject] = []
    var refreshControl: UIRefreshControl!
    @IBOutlet var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 120
        feedTableView.rowHeight = UITableViewAutomaticDimension

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        feedTableView.insertSubview(refreshControl, at: 0)
        
        fetchUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.updates.count
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchUpdates()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red:0.86, green:0.89, blue:0.87, alpha:1.0)
        return headerView
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
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = updates[indexPath.section]
        let user = update["user"] as? PFUser
        let fivesCount = (update["high_fives"] as! NSNumber)
        cell.fiveCountLabel.text = "\(fivesCount)"
        if let event = update["event"] as? PFObject {
            cell.event = event
        }
        cell.section = true
        cell.indexPath = indexPath
        cell.user = user
        cell.post = update
        
        cell.mainBackground.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        cell.fiveButton.addTarget(self, action: #selector(FeedViewController.didPressFive), for: .touchUpInside)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPressFive(_ sender: UIButton) {
        if (sender.isSelected) {
            let storyboard = UIStoryboard(name: "Individual", bundle: nil)
            let popOverVC = storyboard.instantiateViewController(withIdentifier: "highFivePopUp") as! HighFiveViewController
            popOverVC.delegate = self
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.bounds
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }
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
            print(update)
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
            let eventId = (event.objectId)!
            
            
            let vc = segue.destination as! EventDetailViewController
            vc.eventId = eventId
            //vc.org = org
        }
    }
}
