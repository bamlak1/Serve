//
//  CauseDetailViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/31/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class CauseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var cause: PFObject? 
    var pic : PFFile?
    var userList : [String] = []
    
    let user = PFUser.current()

    var orgs : [PFUser] = []
    var upcomingEvents : [PFObject] = []
    var pastEvents : [PFObject] = []
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainImage: PFImageView!
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        let name = cause?["name"] as? String
        causeLabel.text = name
        pic = cause?["image"] as? PFFile
        mainImage.image = nil
        pic?.getDataInBackground(block: { (data: Data?, error: Error?) in
            if (error != nil) {
                print(error?.localizedDescription ?? "error")
            } else {
                let finalImage = UIImage(data: data!)
                self.mainImage.image = finalImage
            }
        })
        
        if let userList = cause?["users"] as? [String] {
            if userList.contains((user!.objectId)!) {
                addButton.isSelected = true
            }
        }
        
        let causesList = user!["causes"] as! [String]
        print(causesList)
        print((cause!.objectId)!)
        if causesList.contains((cause!.objectId)!) {
            print("tru")
            addButton.isSelected = true
        }


        fetchOrgs()
        retrievePastEvents()
        retrieveUpcomingEvents()
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        fetchOrgs()
        retrievePastEvents()
        retrieveUpcomingEvents()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.tableView.rowHeight = 78
            return orgs.count
        case 1:
            self.tableView.rowHeight = 291
            return upcomingEvents.count
        case 2:
            self.tableView.rowHeight = 291
            return pastEvents.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell: UITableViewCell?
        
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrgCell", for: indexPath) as! UserCell
            let org = orgs[indexPath.row]
            cell.indexPath = indexPath
            cell.user = org
            
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = upcomingEvents[indexPath.row]
            cell.event = event
            returnCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            let event = pastEvents[indexPath.row]
            cell.event = event
            returnCell = cell
        default:
            break
        }
        
        return returnCell!
    }
    
    func fetchOrgs(){
        let query = PFUser.query()
        query?.whereKey("causes", equalTo: cause!)
        query?.whereKey("type", equalTo: "Organization")
        
        query?.findObjectsInBackground { (orgs: [PFObject]?, error: Error?) in
            self.orgs = orgs as! [PFUser]
            self.tableView.reloadData()
        }
    }
    
    func retrievePastEvents() {
        
        let date = Date()
        
        let query = PFQuery(className: "Event")
        query.whereKey("start_date", lessThan: date)
        query.order(byDescending: "createdAt")
        query.whereKey("causes", equalTo: cause!)
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.pastEvents = events!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    func retrieveUpcomingEvents() {
        
        let date = Date()
        
        let query = PFQuery(className: "Event")
        query.whereKey("start_date", greaterThan: date)
        query.order(byDescending: "createdAt")
        query.whereKey("causes", equalTo: cause!)
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.upcomingEvents = events!
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    
    
    @IBAction func addPressed(_ sender: Any) {
        if addButton.isSelected {
            user?.remove((user!.objectId)!, forKey: "users")
            if let index = userList.index(of: user!.objectId!){
                userList.remove(at: index)
            }
            addButton.isSelected = false
            user?.saveInBackground()
            
            cause?.remove((user?.objectId)!, forKey: "users")
            cause?.saveInBackground()
            print("removed")
        } else {
            user?.addUniqueObject(cause, forKey: "causes")
            user?.addUniqueObject(causeLabel.text, forKey: "cause_names")
            userList.append((user?.objectId)!)
            addButton.isSelected = true
            user?.saveInBackground()
            
            cause?.addUniqueObject((user?.objectId)!, forKey: "users")
            cause?.saveInBackground()
            print("added")
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "org" {
            let button = sender as! UIButton
            let indexPath = button.tag
            let org = orgs[indexPath] as! PFUser
            let vc = segue.destination as! UserProfileViewController
            vc.user = org
        } else if segue.identifier == "eventCell" {
            let cell = sender as! EventTableViewCell
            let vc = segue.destination as! EventDetailViewController
            vc.eventId = (cell.event.objectId)!
        }

    }
    

}
