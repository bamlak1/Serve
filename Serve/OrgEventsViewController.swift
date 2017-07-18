
//
//  OrgEventsViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse



class OrgEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var upcomingEvents : [PFObject] = []
    var pastEvents : [PFObject] = []
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrganizationViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrievePastEvents()
        retrieveUpcomingEvents()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        retrieveUpcomingEvents()
        retrievePastEvents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
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
        case 1:
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
            cell.descriptionLabel.text = description
            cell.dateTimeLabel.text = "\(start) - \(end)"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return upcomingEvents.count
        case 1:
            return pastEvents.count
        default:
            return 0
        }
    }
    
    func retrieveUpcomingEvents() {
        let org = PFUser.current()
        let id = org!.objectId!
        
        
        let query = PFQuery(className: "Event")
        query.whereKey("authorId", equalTo: id)
        query.whereKey("completed", equalTo: false)
        //TODO: Sort by having closest event at the top
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.upcomingEvents = events!
                self.tableView.reloadData()
                print("Loaded upcoming events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    func retrievePastEvents() {
        let org = PFUser.current()
        let id = org!.objectId!
        
        
        let query = PFQuery(className: "Event")
        query.whereKey("authorId", equalTo: id)
        query.whereKey("completed", equalTo: true)
        //TODO: Sort by having closest event at the top
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.pastEvents = events!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                print("Loaded past events")
            } else {
                print(error?.localizedDescription ?? "error loading data")
            }
        }
        
    }
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellTouch" {
            let cell = sender as! UITableViewCell
            
            if let indexPath = tableView.indexPath(for: cell){
                let event = upcomingEvents[indexPath.row]
                let vc = segue.destination as! OrgEventDetailViewController
                vc.event = event
            }
        }
       
        
     }
     
    
}
