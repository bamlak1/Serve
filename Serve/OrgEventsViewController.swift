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
    var events : [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        retrieveEvents() 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        
        let event = events[indexPath.row]
        let image = event["banner"] as! PFFile
        let description = event["description"] as! String
        let date = event["date"] as! String
        let time = event["time"] as! String
        let title = event["title"] as? String
        
        image.getDataInBackground { (data: Data?, error: Error?) in
            if(error != nil) {
                print(error?.localizedDescription ?? "error")
            } else {
                let finalImage = UIImage(data: data!)
                cell.bannerImageView.image = finalImage
            }
        }
        
        cell.eventNameLabel.text = title
        cell.dateLabel.text = date
        cell.descriptionLabel.text = description
        cell.timeLabel.text = time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func retrieveEvents() {
        let org = PFUser.current()
        let id = org!.objectId!
        
        
        let query = PFQuery(className: "Event")
        query.whereKey("authorId", equalTo: id)
        //TODO: Sort by having closest event at the top
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if events != nil {
                self.events = events!
                self.tableView.reloadData()
                print("Loaded events")
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
