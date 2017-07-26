//
//  MapViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Parse
import SwiftyJSON

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate, UISearchBarDelegate, LocateOnTheMap, SettingsDelegate {
    
    var key = "AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA"
    var searchResultController: SearchResultsViewController!
    var resultsArray = [String]()
    var returnedEvents: [PFObject] = []
    var markers: [GMSMarker] = []
    var previousMarker: GMSMarker!
    var homeMarker: GMSMarker!
    var markerNum = 0
    var drawnCircle: GMSCircle!
    var otherLocationCircle: GMSCircle!
    var userEvents: [Int] = []
    var otherEvents: [Int] = []
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myEventsSwitch: UISwitch!
    @IBOutlet weak var otherEventsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserLocation()
        fetchEventLocations()
        mapView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.backgroundColor = UIColor.clear
        searchResultController = SearchResultsViewController()
        searchResultController.delegate = self
    }
    
    // Given a new marker that was searched using the search bar and a radius in miles, draws a circle around that marker
    // If there was already a circle drawn, replace it with the new one
    func drawOtherLocationCircle(marker: GMSMarker, miles: Int) {
        if (otherLocationCircle != nil) {
            otherLocationCircle.map = nil
        }
        let newCircle = GMSCircle(position: marker.position, radius: Double(miles) * 1609.34)
        newCircle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        newCircle.strokeColor = .red
        newCircle.strokeWidth = 5
        newCircle.map = mapView
        otherLocationCircle = newCircle
        let update = GMSCameraUpdate.fit(newCircle.bounds())
        mapView.animate(with: update)
    }
    
    // Given a radius in miles, draws a circle around the home base
    // If there was already a circle drawn, replaces it with the new one
    func drawHomeCircle(miles: Int) {
        if (drawnCircle != nil) {
            drawnCircle.map = nil
        }
        let newCircle = GMSCircle(position: homeMarker.position, radius: Double(miles) * 1609.34)
        newCircle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        newCircle.strokeColor = .red
        newCircle.strokeWidth = 5
        newCircle.map = mapView
        drawnCircle = newCircle
        let update = GMSCameraUpdate.fit(newCircle.bounds())
        mapView.animate(with: update)
    }

    // Given a type of event (either user or other) and a boolean (true = display, false = hide),
    // displays or hides all those events
    func updateDisplayedEvents(eventType: String, display: Bool) {
        var eventArr = [Int]()
        if (eventType == "userEvents") {
            eventArr = userEvents
        } else {
            eventArr = otherEvents
        }
        
        if (display) {
            for (index, marker) in self.markers.enumerated() {
                if (eventArr.contains(index)) {
                    marker.map = self.mapView
                }
            }
        } else {
            for (index, marker) in self.markers.enumerated() {
                if (eventArr.contains(index)) {
                    marker.map = nil
                }
            }
        }
    }
    
    @IBAction func myEventsDisplay(_ sender: Any) {
        if myEventsSwitch.isOn {
            updateDisplayedEvents(eventType: "userEvents", display: true)
        } else {
            updateDisplayedEvents(eventType: "userEvents", display: false)
        }
    }
    
    @IBAction func otherEventsDisplay(_ sender: Any) {
        if otherEventsSwitch.isOn {
            updateDisplayedEvents(eventType: "otherEvents", display: true)
        } else {
            updateDisplayedEvents(eventType: "otherEvents", display: false)
        }
    }
    
    
    // Displays the settings menu as a pop-up
    @IBAction func showSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let popOverVC = storyboard.instantiateViewController(withIdentifier: "popUpStoryboard") as! MapSettingsViewController
        popOverVC.delegate = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    // Displays the search bar
    @IBAction func showSearchController(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnedEvents.count
    }
    
    // Sets all of the cell information in the CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapEventCell", for: indexPath) as! MapEventCell
        let eventData = returnedEvents[indexPath.item]
        
        if let banner = eventData["banner"] as? PFFile {
            banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.eventImage.image = finalImage
                }
            })
        }
        cell.eventName.text = eventData["title"] as? String
        cell.eventDate.text = (eventData["start"] as? String)! + " - " + (eventData["end"] as? String)!
        cell.orgName.text = eventData["author"] as? String
        cell.location.text = eventData["location"] as? String
        cell.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.9)
        cell.layer.borderWidth = 3.0
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        return cell
    }
    
    // When an event marker is clicked on, uses that marker's associated number to scroll to that event cell in the CollectionView
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let index: Int = ((marker.userData as! Dictionary)["number"])!
        if index > 0 {
            print(index)
            let currentIndexPath = IndexPath(item: index, section: 0)
            print(currentIndexPath)
            self.collectionView.scrollToItem(at: currentIndexPath, at: .right, animated: true)
            self.collectionView.selectItem(at: currentIndexPath, animated: true, scrollPosition: .right)
            update(currentMarker: marker, indexPath: currentIndexPath)
        }
        return true
    }
    
    // When an event cell is clicked on, uses that cell's row number to highlight and shift to that marker on the map
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let marker = markers[indexPath.row]
        print(marker)
        print((marker.userData as! Dictionary)["number"]!)
        update(currentMarker: marker, indexPath: indexPath)
    }
    
    // Given a marker and an IndexPath of the associated cell, updates the colors of the markers (previous and current) and the cell border (current)
    func update(currentMarker: GMSMarker, indexPath: IndexPath) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentMarker.position.latitude, longitude: currentMarker.position.longitude))
        currentMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
        }
    
        if (previousMarker != nil && previousMarker != currentMarker) {
            previousMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0))
        }
        
        previousMarker = currentMarker
    }
    
    // When a different cell is selected, changes the previous cell's border color to black
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.black.cgColor
    }
    
    // Using the user's manually inputed address, geocodes it, centers the map feed to that location, and then creates a marker for it
    func fetchUserLocation() {
        // uncomment when Map View Controller is put back onto the Individual Storyboard
        // let user = PFUser.current()
        
        // Uses a hardcoded user's address
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: "7xAEAEMSxX").continue({
            (task: BFTask!) -> AnyObject! in
            if task.error != nil {
                // There was an error.
                print("User retrieval failed")
            } else {
                let user = task.result as! PFUser
                self.addressToCoordinates(location: user.value(forKey: "address") as! String, type: "home")
            }
            return task
        })
    }
    
    // Using an event's manually inputed address, geocodes it, and adds a marker for it
    // Splits up all the available events into two groups: events the user has signed up for and events the user has not signed up for
    func fetchEventLocations() {
        let query = PFQuery(className: "Event")
        query.order(byAscending: "start")
        query.whereKey("accepted_user", equalTo:"7xAEAEMSxX")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.returnedEvents = events
                self.collectionView.reloadData()
                for (index, eventObject) in events.enumerated() {
                    self.addressToCoordinates(location: eventObject.value(forKey: "location") as! String, type: "event")
                    print("Location: \(eventObject.value(forKey: "location") as! String)")
                    if let acceptedUsers = eventObject.value(forKey: "accepted_users") as? [String] {
                        if acceptedUsers.contains("7xAEAEMSxX") {
                            self.userEvents.append(index)
                        } else {
                            self.otherEvents.append(index)
                        }
                    }
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // When the home button is clicked, returns the map to the home base
    @IBAction func returnHome(_ sender: Any) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: homeMarker.position.latitude, longitude: homeMarker.position.longitude))
    }
    
    // Given an address, converts it into a latitude/longitude, and then maps it
    func addressToCoordinates(location: String, type: String) {
        if (!location.isEmpty) {
            let baseUrlString = "https://maps.googleapis.com/maps/api/geocode/json?"
            let queryString = "address=\(location)&key=\(self.key)"
            
            let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            let request = URLRequest(url: url)
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let dataRetrieval : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    let jsonResult = JSON(data: data)
                    let latitude = Double(jsonResult["results"][0]["geometry"]["location"]["lat"].stringValue)
                    let longitude = Double(jsonResult["results"][0]["geometry"]["location"]["lng"].stringValue)
                    if (type == "home") {
                        self.placeMarker(lat: latitude!, long: longitude!, type: "home")
                    } else {
                        self.placeMarker(lat: latitude!, long: longitude!, type: "event")
                    }
                }
            });
            dataRetrieval.resume()
        } else {
            print("User/organization address not added. Please add address to view map")
        }
    }
    
    // Given the user's latitude and longitude, centers the map at that location and creates a pin for it
    // Gives each marker a number based on what order it was added to the map
    func placeMarker(lat: Double, long: Double, type: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        var extraMarkerInfo = Dictionary<String, Int>()
        if (type == "home") {
            homeMarker = marker
            extraMarkerInfo["number"] = 0
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
            marker.title = "Home base!"
            marker.snippet = "(You can change this in user settings)"
            marker.icon = UIImage(data: UIImagePNGRepresentation(UIImage(named: "home")!)!, scale: 3)!
            drawHomeCircle(miles: 1)
        } else {
            if (type == "changeLocation") {
                extraMarkerInfo["number"] = 0
                marker.title = "Changed Location"
                marker.icon = UIImage(data: UIImagePNGRepresentation(UIImage(named: "star")!)!, scale: 3)!
                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
                drawOtherLocationCircle(marker: marker, miles: 1)
            } else {
                marker.title = "Event"
                marker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0))
                extraMarkerInfo["number"] = markerNum
                markerNum += 1

            }
            marker.userData = extraMarkerInfo
            markers.append(marker)
        }
        marker.map = self.mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Queries all Event objects and reloads the Collection View with events that are ordered by time (sooner events show up first)
    func fetchEvents() {
        let query = PFQuery(className: "Events")
        query.order(byAscending: "date")
        query.addAscendingOrder("time")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.returnedEvents = events
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // Based on what has been typed into the search bar, dynamically updates the results in the table view
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:Error?) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(array: self.resultsArray)
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
