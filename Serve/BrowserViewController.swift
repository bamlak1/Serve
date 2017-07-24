//
//  BrowserViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import SwiftyJSON

class BrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    
    var Events: [PFObject] = []
    var Orgs: [PFObject] = []
    var People: [PFObject] = []
    var user: PFUser!
    var resultsController = UIViewController()
    var filteredEvents = [String]()
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var searchController: UISearchBar!
    
    @IBOutlet weak var collectionView3: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.resultsController.collectionView.dataSource = self
//        self.resultsController.collectionView.delegate = self
        
        
        
        fetchEvents()
//        fetchUsers()
        fetchOrgs()
        fetchPeople()
        
        // Do any additional setup after loading the view.
    }
    
    
//    func updateSearchResults(for searchController: UISearchController) {
//        self.filteredEvents = self.Events.filter { (event: String) -> Bool in
//            if event.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) {
//                return true
//            } else {
//                return false
//            }
//        
//        }
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return Events.count
        } else if collectionView == self.collectionView2 {
            return Orgs.count
        } else {
            return People.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventBrowseCell", for: indexPath) as! EventBrowseCell
            
            
            let eventData = Events[indexPath.item]
            
            if let banner = eventData["banner"] as? PFFile {
                banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        cell.imageViewer.image = finalImage
                    }
                })
            }
            cell.nameLabel.text = eventData["title"] as? String
            
            
            return cell
        } else if collectionView == self.collectionView2 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "OrgBrowseCell", for: indexPath) as! OrgBrowseCell
            
            
            
            let orgData = Orgs[indexPath.item]
            
            if let profPic = orgData["profPic"] as? PFFile {
                profPic.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        cell2.imageViewer.image = finalImage
                    }
                })
            }
            cell2.nameLabel.text = orgData["title"] as? String
            
            
            return cell2
        } else {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleBrowseCell", for: indexPath) as! PeopleBrowseCell
            
            
            
            let peopleData = People[indexPath.item]
            
            if let profPic = peopleData["banner"] as? PFFile {
                profPic.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error != nil) {
                        print(error?.localizedDescription ?? "error")
                    } else {
                        let finalImage = UIImage(data: data!)
                        cell3.imageViewer.image = finalImage
                    }
                })
            }
            cell3.nameLabel.text = peopleData["title"] as? String
            
            
            return cell3
        }
            
    }
    
    //====== SEGUE TO EVENT DETAIL VIEW =======
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {//get this to find the actual post
            let event = Events[indexPath.item] //get the current post
            let eventDetailViewController = segue.destination as! EventDetailViewController //tell it its destination
            eventDetailViewController.event = event
        }
    }
    
    func fetchEvents() {
        let query = PFQuery(className: "Event")
        query.includeKey("user")
        query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.Events = events
                print("Loaded events")
                self.collectionView.reloadData()
                
            }
        }
    }
    
    func fetchOrgs() {
        let query = PFQuery(className: "Event")
        query.includeKey("user")
        query.includeKey("event")
        
        
        query.findObjectsInBackground { (orgs: [PFObject]?, error: Error?) in
            if let orgs = orgs {
                self.Orgs = orgs
                print("Loaded orgs")
                self.collectionView2.reloadData()
                
            }
        }
    }
    
    func fetchPeople() {
        let query = PFQuery(className: "Event")
        query.includeKey("user")
        query.includeKey("event")
        
        
        
        query.findObjectsInBackground { (people: [PFObject]?, error: Error?) in
            if let people = people {
                self.People = people
                print("Loaded ppl")
                self.collectionView3.reloadData()
                
            }
        }
    }
    
    func fetchUsers() {
        let query = PFQuery(className: "_User")
        query.includeKey("type")
        let userType = user?["type"] as! String
        if (userType == "Individual") {
            query.findObjectsInBackground { (people: [PFObject]?, error: Error?) in
                if let people = people {
                    self.People = people
                    print("Loaded ppl")
                    self.collectionView3.reloadData()
                    
                }
            }
        
        } else {
            query.findObjectsInBackground { (orgs: [PFObject]?, error: Error?) in
                if let orgs = orgs {
                    self.Orgs = orgs
                    print("Loaded orgs")
                    self.collectionView2.reloadData()
                    
                }
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
