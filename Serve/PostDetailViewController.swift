//
//  PostDetailViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/26/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var eventButtonOutlet: UIButton!
    
    @IBOutlet weak var nameButtonOutlet: UIButton!
    
    
    @IBOutlet weak var fiveButton: UIButton!
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var fiveCountLabel: UILabel!
    
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var comments: [PFObject]?
    var post: PFObject?
    var event : PFObject?
    var user: PFUser?
    var userType: String?
    var pic : PFFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = (user?["username"] as! String)
        if event != nil {
            eventLabel.text = (event?["title"] as! String)
        }
        actionLabel.text = (post?["action"] as! String)
        userType = (user!["type"] as! String)
        pic = (user!["profile_image"] as! PFFile)
        profilePicImageView.image = nil
        pic?.getDataInBackground { (data: Data?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                let finalImage = UIImage(data: data!)
                self.profilePicImageView.image = finalImage
            }
        }
        if post?["caption"] != nil {
            captionLabel.text = (post?["caption"] as! String)
        }
        let fivesCount = (post?["high_fives"] as! NSNumber)
        fiveCountLabel.text = "\(fivesCount)"
        if event == nil {
            eventButtonOutlet.isEnabled = false
        }

        // Do any additional setup after loading the view.
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        commentTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "PostCommentCell") as! PostCommentCell
        let comment = comments![indexPath.row]
        let text = comment["text"]
        cell.commentLabel.text = text as! String
        if let user = comment["user"] as? PFUser {
            //user found, update username label w username
            cell.nameLabel.text = user.username
            //cell.imageViewer.image = (user["profile_image"] as! PFFile)
        } else {
            //no user found
            cell.nameLabel.text = "🤔🤔🤔🤔"
        }
        //cell.user = PFUser.current()
        
        
        
        return cell
    }
    
    
    @IBAction func didPressView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func didPressPost(_ sender: Any) {
        let postComment = PFObject(className: "comments")
        
        //Store the text of the text field in a key called "text"
        postComment["text"] = commentTextField.text ?? ""
        postComment["user"] = PFUser.current()
        
        postComment.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                print(postComment["text"])
                self.commentTextField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "users" {
            _ = sender as! UIButton
            let user = post?["user"] as! PFUser
            //let id = user.objectId!
            
            
            let vc = segue.destination as! UserProfileViewController
            vc.user = user
        }
        
        if segue.identifier == "event"{
            _ = sender as! UIButton
            let event = post?["event"] as! PFObject
            
            let vc = segue.destination as! EventDetailViewController
            vc.event = event
        }
    }
    
    func onTimer() {
        // Add code to be run periodically
        
        var query = PFQuery(className: "comments")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (retrievedComments: [PFObject]?, error: Error?) in
            self.comments = retrievedComments
            self.commentTableView.reloadData()
        }
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
