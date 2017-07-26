//
//  PendingApprovalsViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class PendingApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PendingCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var pending : [PFObject] = []
    @IBOutlet weak var profileImageView: UIImageView!
    var importedArray : [String] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrganizationViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrievePendingRequests()
        //retrievePendingUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        retrievePendingRequests()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pending") as! PendingCell
        
        let request = pending[indexPath.row]
        let user = request["user"] as! PFUser
        let event = request["event"] as! PFObject
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.event = event
        cell.user = user
        cell.request = request

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pending.count
    }
    
    
    
    func retrievePendingRequests(){
        
        let query = PFQuery(className: "Pending")
        query.whereKey("completed", equalTo: false)
        query.includeKey("user")
        query.includeKey("event")
        
        query.findObjectsInBackground { (pendingList: [PFObject]?, error: Error?) in
            if let pendingList = pendingList {
                self.pending = pendingList
                //print(self.pending)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func didclickOnCellAtIndex(at index: IndexPath) {
        pending.remove(at: index.row)
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.right)
        
        print("button tapped at index:\(index)")
    }
    
    
    
    //Retrieving Users from the event array "Pending_users"
    //    func retrieveUserIDs() {
    //        let org = PFUser.current()
    //        let id = org!.objectId!
    //
    //        let innerQuery = PFQuery(className: "Event")
    //        innerQuery.whereKey("authorId", equalTo: id)
    //        innerQuery.whereKey("completed", equalTo: false)
    //        innerQuery.order(byDescending: "createdAt")
    //        //innerQuery.includeKey("author")
    //        innerQuery.includeKey("pending_users")
    //
    //        innerQuery.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
    //            if let events = events {
    //                print(events)
    //                for event in events {
    //                    let list =  event["pending_users"] as! [String]
    //                    self.importedArray.append(contentsOf: list)
    //                    print(self.importedArray)
    //                }
    //            } else {
    //                print(error?.localizedDescription ?? "error loading data")
    //            }
    //
    //
    //            let query = PFUser.query()
    //            //query?.whereKey("objectId", matchesKey: "pending_users", in: innerQuery)
    //            query?.whereKey("objectId", containedIn: self.importedArray)
    //            query?.limit = 10
    //
    //
    //            query?.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
    //                if let users = users {
    //                    self.pending = users
    //                    print("FINAL:\(self.pending)")
    //                    self.tableView.reloadData()
    //                } else {
    //                    print(error?.localizedDescription ?? "error loading data")
    //                }
    //            }
    //
    //
    //        }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

