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

class MapViewController: UIViewController {
    var key = "AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA"
    var results: NSArray!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserLocation()
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
                print("user retrieval failed")
            } else {
                let user = task.result as! PFUser
                print(task.result)
                
                if (user["address"] != nil) {
                    let baseUrlString = "https://maps.googleapis.com/maps/api/geocode/json?"
                    let queryString = "address=\(user["address"])&key=\(self.key)"
                    
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
                            self.showMap(lat: latitude!, long: longitude!)
                        }
                    });
                    dataRetrieval.resume()
                } else {
                    print("User address not added. Please add address to view map")
                }
            }
            return task
        })
    }
    
    // Given the user's latitude and longitude, centers the map at that location and creates a pin for it
    func showMap(lat: Double, long: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "Home base!"
        marker.snippet = "(You can change this in user settings)"
        marker.map = mapView
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
