//
//  Cause.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import Foundation
import Parse

class Cause {
    var name: String!
    var iconUrl: URL!
    
    init(name: String, iconUrl: URL) {
        self.name = name
        self.iconUrl = iconUrl
    }
    
    
    class func createCause( name: String?, image: UIImage?, completion: PFBooleanResultBlock?) {
        
        let cause = PFObject(className: "Cause")
            
        cause["name"] = name
        cause["image"] = getPFFileFromImage(image: image)
        cause["orgs"] = []
        cause["events"] = []
        
        cause.saveInBackground(block: completion)
            
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image, let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
        
        return nil
        
    }
    
}
