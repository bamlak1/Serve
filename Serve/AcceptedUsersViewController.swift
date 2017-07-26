//
//  AcceptedUsersViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/26/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class AcceptedUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var event: PFObject?
    var users : [PFUser]  = []
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
    

    func retrieveUsers() {
        let query = PFQuery(className: "Event")
        query.whereKey("objectId", equalTo: (event!.objectId)!)
        query.includeKey("accepted_users")
    
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                let event = events!.first
                self.users = event!["accepted_users"] as! [PFUser]
                print(self.users)
                self.tableView.reloadData()
                
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
