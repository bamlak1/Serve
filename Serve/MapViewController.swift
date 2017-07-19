//
//  MapViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import SwiftyJSON

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate {
    var key = "AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA"
    var returnedEvents: [PFObject] = []
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var markerNum = 1
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserLocation()
        fetchEventLocations()
        mapView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnedEvents.count
    }
    
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
        cell.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.9)
        cell.layer.borderWidth = 3.0
        if cell.isSelected {
            cell.layer.borderColor = UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0).cgColor
        } else {
            cell.layer.borderColor = UIColor.black.cgColor
        }
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        return cell
    }
    
    // Uses each marker's associated number to scroll to that event cell in the CollectionView
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let index: Int = (marker.userData as! Dictionary)["number"]!
        print(index)
        if (index != 0) {
            selectedIndexPath = IndexPath(row: index - 1, section: 0)
            self.collectionView.scrollToItem(at: selectedIndexPath, at: .right, animated: true)
            self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .right)
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: selectedIndexPath, animated: true)
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0).cgColor
        }
        if selectedIndexPath != indexPath {
            if let cell = collectionView.cellForItem(at: selectedIndexPath) {
                cell.layer.borderColor = UIColor.black.cgColor
            }
        }
        selectedIndexPath = indexPath
    }
    
    // Using the user's manually inputed address, geocodes it, centers the map feed to that location, and then creates a marker for it
    func fetchUserLocation() {
        // uncomment when Map View Controller is put back onto the Individual Storyboard
        // let user = PFUser.current()
        
        // Uses a hardcoded user's address
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: "6UeK1Im6rs").continue({
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
    func fetchEventLocations() {
        let query = PFQuery(className: "Event")
        query.order(byAscending: "start")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.returnedEvents = events
                self.collectionView.reloadData()
                for eventObject in events {
                    self.addressToCoordinates(location: eventObject.value(forKey: "location") as! String, type: "event")
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
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
        
        var extraMarkerInfo = Dictionary<String, Any>()
        extraMarkerInfo["number"] = markerNum
    
        if (type == "home") {
            extraMarkerInfo["number"] = 0
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
            // Creates a marker in the center of the map.
            marker.title = "Home base!"
            marker.snippet = "(You can change this in user settings)"
            marker.icon = GMSMarker.markerImage(with:UIColor(red:0.16, green:0.35, blue:0.50, alpha:1.0))
        } else {
            extraMarkerInfo["number"] = markerNum
            markerNum += 1
            marker.title = "Event"
            marker.icon = GMSMarker.markerImage(with: UIColor(red:0.34, green:0.71, blue:1.00, alpha:1.0))
        }
        marker.userData = extraMarkerInfo
        marker.appearAnimation = GMSMarkerAnimation.pop
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
