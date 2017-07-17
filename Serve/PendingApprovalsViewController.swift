//
//  PendingApprovalsViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class PendingApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var pending : [PFObject] = []
    var upcomingEvents : [PFObject] = []
    var pendingIDs : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveUserIDs()
        //retrievePendingUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pending") as! PendingCell
        
        let user = pendingIDs[indexPath.row]
        //name = user["username"] as! String
        
        cell.nameLabel.text = user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingIDs.count
    }

    
    func retrievePendingUsers() {
        let query = PFUser.query()
        query?.whereKey("id", equalTo: self.pendingIDs)
        query?.findObjectsInBackground(block: { (users: [PFObject]?, error: Error?) in
            if users != nil {
                self.pending = users!
                print(self.pending)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        })
    
    }
    
    func retrieveUserIDs() {
        let org = PFUser.current()
        let id = org!.objectId!
        
        let innerQuery = PFQuery(className: "Event")
        innerQuery.whereKey("authorId", equalTo: id)
        innerQuery.whereKey("completed", equalTo: false)
        innerQuery.order(byDescending: "createdAt")
        //innerQuery.includeKey("author")
        innerQuery.includeKey("pending_users")
        
        //let query = PFUser.query()
        //query?.whereKey("objectId", matchesKey: "pending_users", in: innerQuery)
        //query?.whereKey("objectId", equalTo: "RICztLBvgj")
        //query.limit = 10
        
        
        innerQuery.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                for event in events {
                    var userIDs = event["pending_users"] as! [PFObject]
                    print(userIDs)
                    
                }
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
        
    }
    
    
//EXAMPLE OF HOW TO GET USERS WITH IDS
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
//        let query = PFUser.query()
//        query?.whereKey("objectId", matchesKey: "pending_users", in: innerQuery)
//        //query?.whereKey("objectId", equalTo: "RICztLBvgj")
//        //query.limit = 10
//        
//        
//        query?.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
//            if users != nil {
//                print(users)
//                let users = users!
//                self.pending = users
//                print("Loaded users:      \(self.pending)")
//            } else {
//                print(error?.localizedDescription ?? "error loading data")
//            }
//        }
//        
//        
//    }

    
      //FUNCTIONALLY GRABS IDS
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
//        //let query = PFUser.query()
//        //query?.whereKey("id", equalTo: self.pendingIDs)
//        //query.limit = 10
//        
//        
//        innerQuery.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
//            if events != nil {
//                let events = events!
//                for event in events {
//                    print(event)
//                    let list =  event["pending_users"] as! [String]
//                    print(list)
//                    //print(event["pendingUsers"])
//                    self.pendingIDs.append(contentsOf: list)
//                    self.tableView.reloadData()
//                }
//                //self.pendingUsers = ids
//                print("Loaded users:      \(self.pendingIDs)")
//            } else {
//                print(error?.localizedDescription ?? "error loading data")
//            }
//        }
//        
//        
//    }
   
    
//    func retrieveUpcomingEvents(){
//        let org = PFUser.current()
//        let id = org!.objectId!
//        
//        
//        let query = PFQuery(className: "Event")
//        query.whereKey("authorId", equalTo: id)
//        query.whereKey("completed", equalTo: false)
//    
//        query.order(byDescending: "createdAt")
//        query.includeKey("author")
//        
//        query.limit = 10
//        
//        
//        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
//            if events != nil {
//                self.upcomingEvents = events!
//                //self.pendingUsers = ids
//                print("Loaded users:      \(self.pendingUsers)")
//            } else {
//                print(error?.localizedDescription ?? "error loading data")
//            }
//        }
//        
//    }
//    

    
//    func getPendingUsers(events: [PFObject]) -> [PFUser] {
//    
//        for event in events {
//            let pendingUsers = event["pending_users"] as! [PFUser]
////            var pendingIDs : [String] = []
////            pendingIDs += pendingUsers
//            
//        }
//        return pendingUsers
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
