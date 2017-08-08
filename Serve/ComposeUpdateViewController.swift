//
//  ComposeUpdateViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/25/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse
import MBProgressHUD

class ComposeUpdateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    
    
    @IBOutlet weak var signUpButton: UIBarButtonItem!
    var event: PFObject?
    var delegate: NotifyEventDelegate!
    var reflection : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.textColor = UIColor.lightGray
        if reflection{
            textView.text = "What did you think about this event?"
        }else {
            textView.text = "What are your thoughts on this event?"
        }
        
        
        setData()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
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
        textView.textColor = UIColor.lightGray
        if textView.text.isEmpty {
            if reflection{
                textView.text = "What did you think about this event?"
            }else {
                textView.text = "What are your thoughts on this event?"
            }
            
        }
    }
    
    
    
    func setData() {
        let user = PFUser.current()!
        print(event)
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
        if reflection{
            actionLabel.text = "went to"
            signUpButton.title = "Done"
            
        }else {
            actionLabel.text = "is interested in"
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        switch reflection{
        case false:
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Pending.postPending(user: PFUser.current()!, event: event!, caption: textView.text, auto: false) { (success: Bool, error: Error?) in
                if
                    success {
                    print("pending request made")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription ?? "error")
                }
            }
            self.delegate.didPressSignUp()
            
            let currentInstallation = PFInstallation.current()
            currentInstallation?.addUniqueObject((event?.objectId)!, forKey: "channels")
            currentInstallation?.addUniqueObject( (PFUser.current()?.objectId)!, forKey: "usersObjectId")
            currentInstallation?.saveInBackground()
        case true:
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Post.userReflectionPost(eventInterest: event!, caption: textView.text) { (success: Bool, error: Error?) in
                if
                    success {
                    print("reflection post made")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription ?? "error")
                }
            } 
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
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
