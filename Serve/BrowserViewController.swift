
//
//  BrowserViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//



//change tap gesture thing, find better way. 
//get rid of collection view once nothing in that group applies


import UIKit
import Parse
import SwiftyJSON

class BrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate  {
    
    
    var Events: [PFObject] = []
    var Orgs: [PFObject] = []
    var People: [PFObject] = []
    
    var filteredEvents: [PFObject] = []
    var filteredOrgs: [PFObject] = []
    var filteredPeople: [PFObject] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
 
    
    @IBOutlet weak var collectionView3: UICollectionView!
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.resultsController.collectionView.dataSource = self
//        self.resultsController.collectionView.delegate = self
        
        searchBar.delegate = self
        
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
    
    @IBAction func didPressView(_ sender: Any) {
        view.endEditing(true)
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredEvents = Events
            filteredOrgs = Orgs
            filteredPeople = People
            
        } else {
            filteredEvents = Events.filter { (event: PFObject) -> Bool in
                let title = event["title"] as! String
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
            }
            filteredOrgs = Orgs.filter { (org: PFObject) -> Bool in
                let title = org["username"] as! String
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
            }
            filteredPeople = People.filter { (person: PFObject) -> Bool in
                let title = person["username"] as! String
                return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
            }
        }
        
        collectionView.reloadData()
        collectionView2.reloadData()
        collectionView3.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return filteredEvents.count
        } else if collectionView == self.collectionView2 {
            return filteredOrgs.count
        } else {
            return filteredPeople.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventBrowseCell", for: indexPath) as! EventBrowseCell
            
            
            let eventData = filteredEvents[indexPath.item]
            cell.event = eventData
            cell.indexPath = indexPath
            
            return cell
        } else if collectionView == self.collectionView2 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "OrgBrowseCell", for: indexPath) as! OrgBrowseCell

            let orgData = filteredOrgs[indexPath.item]
            cell2.user = orgData as! PFUser
            cell2.indexPath = indexPath

            return cell2
        } else {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleBrowseCell", for: indexPath) as! PeopleBrowseCell
            let peopleData = filteredPeople[indexPath.item] as! PFUser
            cell3.user = peopleData
            cell3.indexPath = indexPath
            
            return cell3
        }
            
    }
    
//    //====== SEGUE TO EVENT DETAIL VIEW =======
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let cell = sender as! UICollectionViewCell
//        if let indexPath = collectionView.indexPath(for: cell) {//get this to find the actual post
//            let event = filteredEvents[indexPath.item] //get the current post
//            let eventDetailViewController = segue.destination as! EventDetailViewController //tell it its destination
//            eventDetailViewController.event = event
//        }
//        if let indexPath = collectionView2.indexPath(for: cell) {//get this to find the actual post
//            let org = filteredOrgs[indexPath.item] //get the current post
//            let otherUserViewController = segue.destination as! OtherUserViewController //tell it its destination
//            otherUserViewController.user = org as? PFUser
//        }
//        if let indexPath = collectionView3.indexPath(for: cell) {//get this to find the actual post
//            let person = filteredPeople[indexPath.item] //get the current post
//            let otherUserViewController = segue.destination as! OtherUserViewController //tell it its destination
//            otherUserViewController.user = person as? PFUser
//        }
//        
//    }
    
    
    func fetchEvents() {
        let query = PFQuery(className: "Event")
        query.includeKey("user")
        //query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.Events = events
                self.filteredEvents = events
                //print("Loaded events")
                self.collectionView.reloadData()
                
            }
        }
    }
    
    func fetchOrgs() {
        let query = PFQuery(className: "_User")
        query.includeKey("type")
        query.whereKey("type", equalTo: "Organization")
        query.includeKey("username")
        query.includeKey("profile_image")
        
        
        query.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
            for user in users! {
                let userType = user["type"] as! String
                
                if let orgs = users {
                    if (userType == "Organization") {
                        self.Orgs = orgs
                        self.filteredOrgs = orgs
                        //print("Loaded orgs")
                        self.collectionView2.reloadData()
                        
                    }
                }
                
            }
            
        }
    }
    
    func fetchPeople() {
        let query = PFQuery(className: "_User")
        query.includeKey("type")
        query.whereKey("type", equalTo: "Individual")
        query.includeKey("username")
        query.includeKey("profile_image")
        
        
        query.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
            for user in users! {
                let userType = user["type"] as! String
                
                if let people = users {
                    if (userType == "Individual") {
                        self.People = people
                        self.filteredPeople = people
                        //print("Loaded ppl")
                        self.collectionView3.reloadData()
                        
                    }
                }
                
            }
            
        }
    }
//    
//    func fetchUsers() {
//        let query = PFQuery(className: "_User")
//        query.includeKey("type")
//        query.whereKey("type", equalTo: "Individual")
//        query.includeKey("username")
//        query.includeKey("profile_image")
//        
//        
//        query.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
//            for user in users! {
//                let userType = user["type"] as! String
//                
//                if let people = users {
//                    if (userType == "Individual") {
//                        self.People = people
//                        self.filteredPeople = people
//                        print("Loaded ppl")
//                        self.collectionView3.reloadData()
//                        
//                    }
//                }
//
//                
//            }
//    
//    }
//}
    
    
    
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "event" {
            let button = sender as! UIButton
            let event = filteredEvents[button.tag]
            let vc = segue.destination as! EventDetailViewController
            vc.event = event
        }
        
        if segue.identifier == "ind" {
            let button = sender as! UIButton
            let user = filteredPeople[button.tag] as! PFUser
            let vc = segue.destination as! UserProfileViewController
            vc.user = user
        }
        
        if segue.identifier == "org" {
            let button = sender as! UIButton
            let user = filteredOrgs[button.tag] as! PFUser
            let vc = segue.destination as! UserProfileViewController
            vc.user = user
        }
     }
    
    
}
