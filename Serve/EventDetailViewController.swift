//
//  EventDetailViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class EventDetailViewController: UIViewController {
    
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
        orgLabel.text = event?["author"] as? String
        let start = event?["start"] as! String
        let end = event?["end"] as! String
        dateLabel.text = "\(start) - \(end)"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ComposeUpdateViewController

        vc.event = self.event
     }
    
    
}
