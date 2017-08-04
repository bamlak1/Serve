//
//  Comment.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/27/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import Foundation
import Parse


class Comment: NSObject {
    
    class func userComment(text: String?, withImage image: UIImage?, withDate date: Date?, withCompletion completion: PFBooleanResultBlock?) {
        
        let comment = PFObject(className: "comments")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DMMM d, yyyy"
        let date = dateFormatter.string(from: date!)
        

        let user = PFUser.current()
        comment["user"] = user
        comment["image"] = user?["profile_image"]
        
        comment["text"] = text

        comment["date"] = date
        
        
        // Save object (following function will save the object in Parse asynchronously)
        comment.saveInBackground(block: completion)
        
        
        
        
}
}
