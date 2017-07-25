//
//  ComposeUpdateViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/25/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class ComposeUpdateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var event: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "What are your thoughts on this event?"
        textView.textColor = UIColor.lightGray
        setData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What are your thoughts on this event?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    func setData() {
        let user = PFUser.current()!
        
        if let profileImage = user["profile_image"] as? PFFile {
            profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    self.profileImageView.image = finalImage
                }
            })
        }
        if let name = user["username"] {
            nameLabel.text = (name as! String)
        }
        
        if let eventName = event?["title"] {
            eventLabel.text = (eventName as! String)
        }

    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        Pending.postPending(user: PFUser.current()!, event: event!, caption: textView.text, auto: false) { (success: Bool, error: Error?) in
            if success {
                print("pending request made")
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
        
        
        
    }
 
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
