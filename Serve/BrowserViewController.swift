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

class BrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    var events: [PFObject] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        fetchEvents()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        
//        cell.imgImage.image = imageArroy[indexPath.row]
//        cell.nameLabel.text = imageArroynames[indexPath.row]

        let eventData = events[indexPath.item]
        
        if let banner = eventData["banner"] as? PFFile {
            banner.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.imgImage.image = finalImage
                }
            })
        }
        cell.nameLabel.text = eventData["title"] as? String
        
        
        return cell
    }
    
    func fetchEvents() {
        let query = PFQuery(className: "Event")
        query.includeKey("user")
        query.includeKey("event")
        query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if let events = events {
                self.events = events
                print("Loaded events")
                self.collectionView.reloadData()
                
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
