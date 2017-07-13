//
//  Event.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//


import Foundation
import UIKit
import Parse

class Event: NSObject {
    
    class func postEvent(image: UIImage?, title: String?, description: String?, location: String?, date: String?,time: String?, jobs: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let event = PFObject(className: "Event")
        
        event["authorId"] = PFUser.current()?.objectId!
        event["title"] = title
        event["banner"] = getPFFileFromImage(image: image)
        event["description"] = description
        event["author"] = PFUser.current()
        event["location"] = location
        event["date"] = date
        event["time"] = time
        event["completed"] = false
        event["hiring"] = true
        event["volunteers"] = 0
        event["expected_tasks"] = jobs
        //event["goals"] = goals
        //TODO: event sponsors & other event properties
        
        event.saveInBackground(block: completion)
    }
    
    
    
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image, let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
        
        return nil
        
    }
    
}
