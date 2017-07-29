//
//  PostDetailViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/26/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

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
    
    
    var comments: [PFObject]?
    var update: PFObject?
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
        if event == nil {
            eventButtonOutlet.isEnabled = false
        }

        // Do any additional setup after loading the view.
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
        } else {
            //no user found
            cell.nameLabel.text = "🤔🤔🤔🤔"
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
