
//
//  Pending.swift
//  Serve
//
//  Created by Michael Hamlett on 7/17/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import Foundation
import Parse

class Pending: NSObject {
    
    class func postPending(user: PFUser, event: PFObject, auto: Bool, withCompletion completion: PFBooleanResultBlock?) {
        
        let pendingRequest = PFObject(className: "Pending")
        
        pendingRequest["user"] = user
        pendingRequest["event"] = event
        pendingRequest["accepted"] = false
        let eventTitle = event["title"] as! String
        pendingRequest["event_name"] = eventTitle
        pendingRequest["user_name"] = user["username"]
        pendingRequest["completed"] = false
        
        Post.userInterestedPost(eventInterest: event, title: eventTitle) { (success: Bool, error: Error?) in
            if success {
                print("interestPost created")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
        
        pendingRequest.saveInBackground(block: completion)
    }
    
    
    
    
    
    
    
}
