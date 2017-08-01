
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

class BrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UITabBarDelegate  {
    
    
    var Events: [PFObject] = []
    var Orgs: [PFObject] = []
    var People: [PFObject] = []
    var causes : [PFObject] = []
    
    var filteredEvents: [PFObject] = []
    var filteredOrgs: [PFObject] = []
    var filteredPeople: [PFObject] = []
    var filteredCauses : [PFObject] = []
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var collectionView4: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView3.delegate = self
        collectionView3.dataSource = self
        collectionView4.delegate = self
        collectionView4.dataSource = self
        scrollView.contentSize = (scrollView.frame.size)
        
        //self.automaticallyAdjustsScrollViewInsets = false
        
        fetchEvents()
        fetchOrgs()
        fetchPeople()
        fetchCauses()
    }
    
    

    
    @IBAction func didPressView(_ sender: Any) {
        view.endEditing(true)
    }
  


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //==========================Collection View=======================================\\
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return filteredEvents.count
        } else if collectionView == self.collectionView2 {
            return filteredOrgs.count
        } else if collectionView == self.collectionView3 {
            return filteredPeople.count
        } else {
            return filteredCauses.count
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
        } else if collectionView == self.collectionView3 {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleBrowseCell", for: indexPath) as! PeopleBrowseCell
            let peopleData = filteredPeople[indexPath.item] as! PFUser
            cell3.user = peopleData
            cell3.indexPath = indexPath
            
            return cell3
        } else {
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "CauseCell", for: indexPath) as! CauseCell
            let cause = filteredCauses[indexPath.item]
            cell4.cause = cause
            cell4.indexPath = indexPath
            
            return cell4
            
        }
        
    }

    //===============================Fetching Data====================================\\
    
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
            
            if let orgs = users {
                
                self.Orgs = orgs
                self.filteredOrgs = orgs
                //print("Loaded orgs")
                self.collectionView2.reloadData()
                
                
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
            
            
            if let people = users {
                
                self.People = people
                self.filteredPeople = people
                //print("Loaded ppl")
                self.collectionView3.reloadData()
                
            }
        }
        
        
    }
    
    func fetchCauses(){
        let query = PFQuery(className: "Cause")
        
        query.findObjectsInBackground { (causes: [PFObject]?, error: Error?) in
            self.causes = causes!
            self.filteredCauses = causes!
            self.collectionView4.reloadData()
        }
    }
    
    
    //================================================================================\\
    
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
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
   
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
        
        if segue.identifier == "cause" {
            let button = sender as! UIButton
            let cause = filteredCauses[button.tag]
            //let id = cause["objectId"] as! String
            let vc = segue.destination as! CauseDetailViewController
            vc.cause = cause
        }
     }
    
    
}
