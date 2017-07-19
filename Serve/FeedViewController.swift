//
//  FeedViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    
    var isMoreDataLoading = false
    var user: PFUser?
    var updates: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchUpdates()
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (!isMoreDataLoading) {
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//            
//            // When the user has scrolled past the threshold, start requesting
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
//                isMoreDataLoading = true
//                
//              //  loadMoreData()
//            
//            }
//        }
//    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchUpdates()
    }

    
    func fetchUpdates() {
        let query = PFQuery(className: "Post")
        query.includeKey("org")
        query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (updates: [PFObject]?, error: Error?) in
            if let updates = updates {
                self.updates = updates
                print("Loaded updates")
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
    }

//    func loadMoreData() {
//        
//        // ... Create the NSURLRequest (myRequest) ...
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = URLSession(configuration: URLSessionConfiguration.default,
//                                 delegate:nil,
//                                 delegateQueue:OperationQueue.main
//        )
//        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // ... Use the new data to update the data source ...
//            
//            // Reload the tableView now that there is new data
//            self.myTableView.reloadData()
//        })
//        task.resume()
//    }

    
    
//    override func viewWillAppear(_ animated: Bool) {
//        fetchData()
//        tableView.contentOffset = CGPoint(x: 0, y: 0) //jumps tableView back up to the top
//    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    
    @IBAction func didPressProfPic(_ sender: Any) {
        let userType = user?["type"] as! String
        if (userType == "Individual"){
            self.performSegue(withIdentifier: "individualProfile", sender: nil)
        } else {
            self.performSegue(withIdentifier: "organizationProfile", sender: nil)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = updates[indexPath.row]
        let org = update["org"] as! PFObject
        //print(org)
        let event = update["event"] as! PFObject
        let orgName = org["username"] as! String
        let eventTitle = event["title"] as! String
        let action = update["action"] as! String
        
        if let profileImage = org["profile_image"] as? PFFile{
            profileImage.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.profilePicImageView.image = finalImage
                }
            }
        }
        
        cell.nameLabel.text = orgName
        cell.actionLabel.text = action
        cell.eventLabel.text = eventTitle
        
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
