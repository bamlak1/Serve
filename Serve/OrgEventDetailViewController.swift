
//
//  OrgEventDetailViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/17/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse

class OrgEventDetailViewController: UIViewController {
    
    var event: PFObject?
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var volunteerLabel: UILabel!
    @IBOutlet weak var expectedTasksLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        titleLabel.text = event?["title"] as? String
        let name = event?["org_name"] as! String
        orgLabel.text = name
        let start = event?["start"] as! String
        let end = event?["end"] as! String
        let prefix = String(start.characters.prefix(10))
        if end.hasPrefix(prefix) {
            let suffixIndex = end.index(end.endIndex, offsetBy: -9)
            let newEnd = end.substring(from: suffixIndex)
            dateLabel.text = "\(start) - \(newEnd)"
        } else {
            dateLabel.text = "\(start) - \(end)"
        }

        locationLabel.text = (event?["location"] as! String)
        descriptionLabel.text = (event?["description"] as! String)
        let pendingCount = event?["pending_count"] as? Int ?? 0
        pendingLabel.text = "\(pendingCount) pending requests"
        let volunteerCount = event?["volunteers"] as? Int ?? 0
        volunteerLabel.text = "\(volunteerCount) volunteers"
        expectedTasksLabel.text = (event?["expected_tasks"] as! String)
        
        
        let image = event?["banner"] as! PFFile
        image.getDataInBackground { (data: Data?, error: Error?) in
            if(error != nil) {
                print(error?.localizedDescription ?? "error")
            } else {
                let finalImage = UIImage(data: data!)
                self.bannerImageView.image = finalImage
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func sendPostNotf(_ sender: Any) {
        
        let param = ["eventId" : (event!.objectId)!, "title" : (titleLabel.text)!] as [String : Any]
        PFCloud.callFunction(inBackground: "sendPost", withParameters: param) { (object: Any?, error: Error?) in
            guard error == nil else {
                print("error")
                return
            }
        }
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accepted" {
            let vc = segue.destination as! AcceptedUsersViewController
            vc.event = event
        }
    }
    
    
}
