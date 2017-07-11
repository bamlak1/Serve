//
//  PersonalUser.swift
//  
//
//  Created by Olga Andreeva on 7/11/17.
//
//

import UIKit

class PersonalUser: NSObject {
    var name: String
    var profileImage: URL?
    var following: Int?
    var friends: Int?
    var age: Int?
    var dictionary: [String: Any]?
    var address: String?
    var volunteerInterests: [String]?
    var events: [Event]?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        following = dictionary["following"] as? Int
        friends = dictionary["followers"] as? Int
        age = dictionary["age"] as? Int
        let profileURL = dictionary["profile_image_url"] as! String
        profileImage = URL(string: profileURL)
        
        let user = PFUser.current()
        let profileImage = user?.value(forKey: "profilePicture") as! PFFile
    }
    
}
