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
    
    class func userComment(caption: String?, withImage image: UIImage?, withDate date: Date?, withCompletion completion: PFBooleanResultBlock?) {
        
        let comment = PFObject(className: "comments")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DMMM d, yyyy"
        let date = dateFormatter.string(from: date!)
        

        comment["user"] = PFUser.current()
        comment["caption"] = caption

        comment["date"] = date
        
        
        // Save object (following function will save the object in Parse asynchronously)
        comment.saveInBackground(block: completion)
        
        
        
        
}
}
