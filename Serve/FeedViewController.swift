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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    
    var isMoreDataLoading = false
    var currentUser = PFUser.current()
    var updates: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    

    @IBOutlet var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        feedTableView.insertSubview(refreshControl, at: 0)
        
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
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let update = updates[indexPath.row]
        let user = update["user"] as? PFUser
        let event = update["event"] as! PFObject
        cell.indexPath = indexPath
        cell.user = user
        cell.event = event
        cell.post = update
        
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        if let indexPath = feedTableView.indexPath(for: cell) {//get this to find the actual post
            let update = updates[indexPath.item] //get the current post
            let postDetailViewController = segue.destination as! PostDetailViewController //tell it its destination
            //postDetailViewController.update = update
        }
        
        
        if segue.identifier == "other" {
            let button = sender as! UIButton
            let indexPath = button.tag
            let update = updates[indexPath]
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
            
            let vc = segue.destination as! EventDetailViewController
            vc.event = event
        }
    }
}
