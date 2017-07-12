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


    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profPicImageView: UIImageView!
    
    @IBOutlet weak var eventBannerImageView: UIImageView!
    
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    @IBOutlet weak var eventTasksLabel: UILabel!
    var event: PFObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user["type"] == "individual" {
            profPicImageView.layer.cornerRadius = profPicImageView.frame.size.width / 2;
            profPicImageView.clipsToBounds = true;
        } else {
            profPicImageView = self
        }
        
        if let event = event {
            let user = event["user"] as! PFUser
            nameLabel.text = event["author"] as! String
            eventDescriptionLabel.text = event["description"] as? String
            eventDateLabel.text = event["date"] as! String
            eventTimeLabel.text = event["time"] as? String
            eventTasksLabel.text = event["expected_tasks"] as! String
            let banner = event["banner"] as! PFFile
            banner.getDataInBackground { (imageData: Data!, error: Error?) in
                self.eventBannerImageView.image = UIImage(data:imageData)
            }
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
