//
//  FeedViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var Updates: [PFObject]?
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        activityIndicator.startAnimating()
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }

    
    func fetchData() {
        let query = PFQuery(className: "update")
        query.addDescendingOrder("createdAt")
        query.limit = 40
        query.includeKey("user")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (updates: [PFObject]?, error: Error?) in
            if let updates = updates {
                // do something with the array of object returned by the call
                self.Updates = updates
                self.tableView.reloadData()
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.contentOffset = CGPoint(x: 0, y: 0) //jumps tableView back up to the top
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Updates?.count ?? 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = Updates![indexPath.row]
        let photo = update["media"] as! PFFile
        let name = update["user"] as! PFUser
        
        
        
        
        cell.nameLabel.text = name as? String
        
        if let date = update["date"]{
            cell.dateLabel.text = date as? String
        } else {
            cell.dateLabel.text = "No Date"
        }
        
        
        //set the photo image
        photo.getDataInBackground { (imageData: Data!, error: Error?) in
            cell.profilePicImageView.image = UIImage(data:imageData)
        }
        
//        if let profPic = user["portrait"] as? PFFile {
//            profPic.getDataInBackground { (imageData: Data!, error: Error?) in
//                cell.profileViewer.image = UIImage(data:imageData)
//            }
//        }
        
        return cell
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
