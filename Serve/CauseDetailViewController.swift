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

    var orgs : [PFUser] = []
    var upcomingEvents : [PFObject] = []
    var pastEvents : [PFObject] = []
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainImage: PFImageView!
    @IBOutlet weak var causeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        causeLabel.text = cause?["name"] as? String
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


        fetchOrgs()
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
        query?.whereKey("causes", equalTo: cause)
        query?.whereKey("type", equalTo: "Organization")
        
        query?.findObjectsInBackground { (orgs: [PFObject]?, error: Error?) in
            self.orgs = orgs as! [PFUser]
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
