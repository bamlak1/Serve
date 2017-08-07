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
import CoreLocation

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate, UISearchBarDelegate, LocateOnTheMap, SettingsDelegate, CLLocationManagerDelegate {
    
    var key = "AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA"
    var searchResultController: SearchResultsViewController!
    var resultsArray = [String]()
    var returnedEvents: [PFObject] = []
    var markers: [GMSMarker] = []
    var previousMarker: GMSMarker!
    var homeMarker: GMSMarker!
    var newLocationMarker: GMSMarker!
    var markerNum = 0
    var userMarkerNum = 0
    var otherMarkerNum = 0
    var homeCircle: GMSCircle!
    var otherLocationCircle: GMSCircle!
    var userEvents: [PFObject] = []
    var otherEvents: [PFObject] = []
    var userMarkers: [GMSMarker] = []
    var otherMarkers: [GMSMarker] = []
    var userEventsShow: Bool!
    var otherEventsShow: Bool!
    var radius: Int!
    var userID = PFUser.current()?.objectId
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEventLocations()
        userEventsShow = UserDefaults.standard.bool(forKey: "userSwitchState")
        otherEventsShow = UserDefaults.standard.bool(forKey: "otherSwitchState")
        fetchUserLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        mapView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.backgroundColor = UIColor.clear
        searchResultController = SearchResultsViewController()
        searchResultController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDisplayedEvents(eventType: "userEvents")
        updateDisplayedEvents(eventType: "otherEvents")
        if (previousMarker != nil) {
            previousMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0)

)
        }
        mapView.selectedMarker = nil
    }
    
    @IBAction func fetchCurrentLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let marker = GMSMarker()
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        let extraMarkerInfo = PFObject(className: "Marker")
        extraMarkerInfo["number"] = -1
        extraMarkerInfo["id"] = "currentLocation"
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
        marker.icon = UIImage(data: UIImagePNGRepresentation(UIImage(named: "navigation")!)!, scale: 3)!
        marker.zIndex = 1
        marker.map = self.mapView
        marker.userData = extraMarkerInfo
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func determineCircleChanges(miles: Int) {
        if (newLocationMarker != nil) {
            let otherPosition = newLocationMarker.position
            let isOtherVisible = self.mapView.projection.contains(otherPosition)
            
            if (isOtherVisible) {
                drawHomeCircle(miles: miles)
                drawOtherLocationCircle(marker: newLocationMarker, miles: miles)
                let update = GMSCameraUpdate.fit(otherLocationCircle.bounds())
                mapView.animate(with: update)
            } else {
                drawOtherLocationCircle(marker: newLocationMarker, miles: miles)
                drawHomeCircle(miles: miles)
                let update = GMSCameraUpdate.fit(homeCircle.bounds())
                mapView.animate(with: update)
            }
        } else {
            drawHomeCircle(miles: miles)
        }
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
    }
    
    // Given a radius in miles, draws a circle around the home base
    // If there was already a circle drawn, replaces it with the new one
    func drawHomeCircle(miles: Int) {
        if (homeCircle != nil) {
            homeCircle.map = nil
        }
        
        let newCircle = GMSCircle(position: homeMarker.position, radius: Double(miles) * 1609.34)
        newCircle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        newCircle.strokeColor = .red
        newCircle.strokeWidth = 5
        newCircle.map = mapView
        homeCircle = newCircle
        
        let update = GMSCameraUpdate.fit(homeCircle.bounds())
        mapView.animate(with: update)
    }
    
    // Given a type of event (either user or other) and a boolean (true = display, false = hide),
    // displays or hides all those events and their corresponding markers
    func updateDisplayedEvents(eventType: String) {
        userEventsShow = UserDefaults.standard.bool(forKey: "userSwitchState")
        otherEventsShow = UserDefaults.standard.bool(forKey: "otherSwitchState")
        if (eventType == "userEvents") {
            for marker in userMarkers {
                if (userEventsShow) {
                    marker.map = self.mapView
                } else {
                    marker.map = nil
                }
            }
        } else {
            for marker in otherMarkers {
                if (otherEventsShow) {
                    marker.map = self.mapView
                } else {
                    marker.map = nil
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    // Displays the MapSettingsViewController as a pop-up
    @IBAction func openSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Individual", bundle: nil)
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
    
    // Returns how many items are in the CollectionView depending on which events should be displayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (userEventsShow && otherEventsShow) {
            return returnedEvents.count
        } else if userEventsShow {
            return userEvents.count
        } else {
            return otherEvents.count
        }
    }
    
    // Sets all of the cell information in the CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapEventCell", for: indexPath) as! MapEventCell
        var eventData = PFObject(className: "Event")
        var showEvents = true
        
        collectionView.isHidden = false
        if (userEventsShow && otherEventsShow) {
            eventData = returnedEvents[indexPath.item]
        } else if userEventsShow {
            eventData = userEvents[indexPath.item]
        } else if otherEventsShow {
            eventData = otherEvents[indexPath.item]
        } else {
            showEvents = false
            collectionView.isHidden = true
        }
        
        if (showEvents) {
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
        }
        return cell
    }
    
    // When an event marker is clicked on, uses that marker's associated number to scroll to that event cell in the CollectionView and displays a custom info window
    // If the home marker is tapped, displays the default info window
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var index = (marker.userData as! PFObject)["number"] as! Int
        if (index == -1) {
             mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
            if (previousMarker != nil) {
                previousMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0)

)
            }
        } else {
            if (userEventsShow && otherEventsShow) {
                index = (marker.userData as! PFObject)["number"] as! Int
            } else if userEventsShow {
                index = (marker.userData as! PFObject)["userMarkerNum"] as! Int
            } else {
                index = (marker.userData as! PFObject)["otherMarkerNum"] as! Int
            }

            let currentIndexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: currentIndexPath, at: .right, animated: true)
            self.collectionView.selectItem(at: currentIndexPath, animated: true, scrollPosition: .right)
            update(currentMarker: marker, indexPath: currentIndexPath)
        } 
        mapView.selectedMarker = marker
        marker.zIndex = 2
        return true
    }
    
    // Creates a custom info window for each marker
    // Information includes how many people ha ve already registered to volunteer and a button that is linked to the event page
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if (marker.userData as! PFObject)["id"] as! String == "home" {
            let infoWindow = Bundle.main.loadNibNamed("HomeWindow", owner: self, options: nil)?.first
            return (infoWindow as! UIView)
        } else if (marker.userData as! PFObject)["id"] as! String == "newLocation" {
            let infoWindow = Bundle.main.loadNibNamed("OtherWindow", owner: self, options: nil)?.first
            return (infoWindow as! UIView)
        } else if (marker.userData as! PFObject)["id"] as! String == "currentLocation" {
            let infoWindow = Bundle.main.loadNibNamed("CurrentLocationWindow", owner: self, options: nil)?.first
            return (infoWindow as! UIView)
        } else {
            let customInfoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
            customInfoWindow.registered.isHidden = true
            let volunteerNum = (marker.userData as! PFObject)["volunteers"] as! Int
            if (marker.userData as! PFObject)["userMarkerNum"] != nil {
                customInfoWindow.registered.isHidden = false
                customInfoWindow.register.isHidden = true
                customInfoWindow.registered.layer.cornerRadius = 10
            }

            customInfoWindow.register.layer.cornerRadius = 10
            customInfoWindow.clipsToBounds = true
            if (volunteerNum == 1) {
                customInfoWindow.volunteerLabel.text = "\(volunteerNum) volunteer"
            } else {
                customInfoWindow.volunteerLabel.text = "\(volunteerNum) volunteers"
            }
            return customInfoWindow
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if ((marker.userData as! PFObject)["id"] as! String != "home" && (marker.userData as! PFObject)["id"] as! String != "newLocation") {
            self.performSegue(withIdentifier: "MapToDetail", sender: self)
        }
    }
    
    // When an event cell is clicked on, uses that cell's row number to highlight and shift to that marker on the map
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MapEventCell
        for marker in markers {
            if (cell.location.text == (marker.userData as! PFObject)["location"] as? String) {
                update(currentMarker: marker, indexPath: indexPath)
                mapView.selectedMarker = marker
                marker.zIndex = 1
            }
        }
            
    }
    
    // Given a marker and an IndexPath of the associated cell, updates the colors of the markers (previous and current) and the cell border (current)
    func update(currentMarker: GMSMarker, indexPath: IndexPath) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentMarker.position.latitude, longitude: currentMarker.position.longitude))
        currentMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.47, green:0.83, blue:0.48, alpha:1.0))
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
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: userID!).continue({
            (task: BFTask!) -> AnyObject! in
            if task.error != nil {
                // There was an error.
                print("User retrieval failed")
            } else {
                let user = task.result as! PFUser
                print(self.userID)
                self.addressToCoordinates(location: user.value(forKey: "address") as! String, type: "home", id: "home", eventObject: user)
            }
            return task
        })
    }
    
    @IBAction func refreshEvents(_ sender: Any) {
        userEventsShow = UserDefaults.standard.bool(forKey: "userSwitchState")
        otherEventsShow = UserDefaults.standard.bool(forKey: "otherSwitchState")
        homeMarker.map = nil
        fetchUserLocation()
        
        let block = {
            self.fetchEventLocations()
        }
        
        emptyEverything(completion: block)
    }
    
    func emptyEverything(completion: () -> ()) {
        for marker in markers {
            marker.map = nil
        }
        self.returnedEvents.removeAll()
        self.userEvents.removeAll()
        self.otherEvents.removeAll()
        self.userMarkers.removeAll()
        self.otherMarkers.removeAll()
        self.markers.removeAll()
        self.markerNum = 0
        self.userMarkerNum = 0
        self.otherMarkerNum = 0
        mapView.selectedMarker = nil
        if (previousMarker != nil) {
            previousMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0)

)
        }
        completion()
    }
    
    // Using an event's manually inputed address, geocodes it, and adds a marker for it
    // Splits up all the available events into two groups: events the user has signed up for and events the user has not signed up for
    func fetchEventLocations() {
        let query = PFQuery(className: "Event")
        query.order(byAscending: "start")
        query.findObjectsInBackground() { (events: [PFObject]?, error: Error?) in
            if let events = events {
                for eventObject in events {
                    if let acceptedUsers = eventObject.value(forKey: "accepted_ids") as? [String] {
                        if (acceptedUsers.contains(self.userID!)) {
                            self.userEvents.append(eventObject)
                            self.addressToCoordinates(location: eventObject.value(forKey: "location") as! String, type: "userEvent", id: self.userID!, eventObject: eventObject)
                            self.returnedEvents.append(eventObject)
                        } else {
                            self.otherEvents.append(eventObject)
                            self.addressToCoordinates(location: eventObject.value(forKey: "location") as! String, type: "otherEvent", id: "other", eventObject: eventObject)
                            self.returnedEvents.append(eventObject)
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
        let update = GMSCameraUpdate.fit(homeCircle.bounds())
        mapView.animate(with: update)
        mapView.selectedMarker = homeMarker
        if (previousMarker != nil) {
            previousMarker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0)

)
        }
    }
    
    // Given an address, converts it into a latitude/longitude, and then maps it
    func addressToCoordinates(location: String, type: String, id: String, eventObject: PFObject) {
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
                        self.placeMarker(lat: latitude!, long: longitude!, type: "home", id: id, location: location, eventObject: eventObject)
                    } else {
                        self.placeMarker(lat: latitude!, long: longitude!, type: type, id: id, location: location, eventObject: eventObject)
                    }
                }
            });
            dataRetrieval.resume()
        }
    }
    
    // Given the user's latitude and longitude, centers the map at that location and creates a pin for it
    // Gives each marker a number based on what order it was added to the map
    func placeMarker(lat: Double, long: Double, type: String, id: String, location: String, eventObject: PFObject) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let extraMarkerInfo = PFObject(className: "Marker")
        extraMarkerInfo["id"] = id
        extraMarkerInfo["event"] = eventObject
        if (type == "home") {
            homeMarker = marker
            extraMarkerInfo["number"] = -1
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
            marker.title = "Home base!"
            marker.snippet = "(You can change this in user settings)"
            marker.icon = UIImage(data: UIImagePNGRepresentation(UIImage(named: "home")!)!, scale: 3)!
            marker.zIndex = 1
            drawHomeCircle(miles: Int(UserDefaults.standard.float(forKey: "slider_value")))
            marker.map = self.mapView
        } else if (type == "changeLocation") {
            newLocationMarker = marker
            extraMarkerInfo["number"] = -1
            marker.title = "Changed Location"
            marker.icon = UIImage(data: UIImagePNGRepresentation(UIImage(named: "star")!)!, scale: 3)!
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
            drawOtherLocationCircle(marker: marker, miles: Int(UserDefaults.standard.float(forKey: "slider_value")))
             marker.map = self.mapView
        } else {
            marker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0)

)
            extraMarkerInfo["location"] = location
            extraMarkerInfo["number"] = markerNum
            extraMarkerInfo["volunteers"] = eventObject["volunteers"]
            markerNum += 1
            markers.append(marker)
            
            if (type == "userEvent") {
                extraMarkerInfo["userMarkerNum"] = userMarkerNum
                userMarkerNum += 1
                userMarkers.append(marker)
                if (userEventsShow) {
                    marker.map = self.mapView
                } else {
                    marker.map = nil
                }
            } else if (type == "otherEvent") {
                extraMarkerInfo["otherMarkerNum"] = otherMarkerNum
                otherMarkerNum += 1
                otherMarkers.append(marker)
                if (otherEventsShow) {
                    marker.map = self.mapView
                } else {
                    marker.map = nil
                }
            }
        }
        marker.userData = extraMarkerInfo
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(array: self.resultsArray)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "MapToDetail" {
             let vc = segue.destination as! EventDetailViewController
            let event = (previousMarker.userData as! PFObject)["event"] as! PFObject
             vc.eventId = event.objectId
        }
     }


}
