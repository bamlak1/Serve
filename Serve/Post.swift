//
//  Post.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import Foundation


class Post {
    
    // MARK: Properties
    var id: Int64 // For fiving and reposting
    var text: String // Text content of post
    var fiveCount: Int // Update five count label
    var fived: Bool? // Configure five button
    var user: User // Contains name, pic, interests, etc. of post author
    var createdAtString: String // Display date
    var repostedByUser: User?  // user who reposted if post is repost
    var displayURL: URL?
    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        
        var dictionary = dictionary
        
        // Is this a repost?
        if let originalPost = dictionary["reposted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.repostedByUser = User(dictionary: userDictionary)
            
            // Change post to original post
            dictionary = originalPost
        }
        
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        fiveCount = dictionary["five_count"] as! Int
        fived = dictionary["fived"] as? Bool
        
        
        //getting the photo out of the post body
        let entities = dictionary["entities"] as! [String: Any]
        if let media = entities["media"] as? [[String: Any]] {
            let firstMediaItem = media[0]
            let displayURLString = firstMediaItem["media_url_https"] as! String
            displayURL = URL(string: displayURLString)
        }
        
        // Initialize user
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        // Format and set createdAtString (aka timestamp)
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        createdAtString = formatter.string(from: date)
        
        
    }
}
