
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
        pendingRequest["event_name"] = event["title"]
        pendingRequest["user_name"] = user["username"]
        pendingRequest["completed"] = false
        
        
        pendingRequest.saveInBackground(block: completion)
    }
    
    
    
    
    
    
    
}
