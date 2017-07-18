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

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var key = "AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA"
    var returnedEvents: [PFObject] = []
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserLocation()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnedEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapEventCell", for: indexPath) as! MapEventCell
        let eventData = returnedEvents[indexPath.item]
        
        cell.eventImage.image = eventData["banner"] as? UIImage
        cell.eventName.text = eventData["title"] as? String
        cell.eventTime.text = (eventData["date"] as! String) + " " + (eventData["time"] as! String)
        cell.orgName.text = eventData["author"] as? String
        fetchEventLocations()
        return cell
    }
    
    // Using the user's manually inputed address, geocodes it, centers the map feed to that location, and then creates a pin for it
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
    
    func fetchEventLocations() {
        let query = PFQuery(className: "Event")
        query.findObjectsInBackground().continue ({
            (task: BFTask!) -> AnyObject! in
            if task.error != nil {
                // There was an error.
                print("User retrieval failed")
            } else {
                let events = task.result
                for eventObject in events! {
                    if let event = eventObject as? Event {
                        self.addressToCoordinates(location: event.value(forKey: "location") as! String, type: "event")
                    }
                }
            }
            return task
        })
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
                    print(jsonResult)
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
    
    // Given the user's latitude and longitude, centers the map at that location and creates a pin for it
    func placeMarker(lat: Double, long: Double, type: String) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = mapView
        if (type == "home") {
            // Creates a marker in the center of the map.
            marker.title = "Home base!"
            marker.snippet = "(You can change this in user settings)"
            marker.icon = GMSMarker.markerImage(with: .white)
        } else {
            marker.icon = GMSMarker.markerImage(with: .green)
        }
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
