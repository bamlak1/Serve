//
//  Following.swift
//  Serve
//
//  Created by Michael Hamlett on 8/7/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import Foundation
import Parse

class Following {
    
    
    class func createFollow( owner: String?, completion: PFBooleanResultBlock?) {
        
        let follow = PFObject(className: "Follow")
        
        follow["count"] = 0
        follow["owner"] = owner
        follow["others"] = []
        
        follow.saveInBackground(block: completion)
        
    }
    
    

}
