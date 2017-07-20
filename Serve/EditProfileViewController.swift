//
//  EditOrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    
    //Variable that is used to determine which imageview to fill when an image is selected
    var bannerPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        contactTextView.delegate = self
//        missionTextView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateBannerImagePressed(_ sender: Any) {
        bannerPressed = true
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        vc.sourceType = .photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateProfileImagePressed(_ sender: Any) {
        bannerPressed = false
        let vc2 = UIImagePickerController()
        vc2.delegate = self
        vc2.allowsEditing = true
        
        vc2.sourceType = UIImagePickerControllerSourceType.photoLibrary
        vc2.sourceType = .photoLibrary
        
        self.present(vc2, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if bannerPressed == true {
            bannerView.image = editedImage
        } else {
            profileImageView.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        if let user = PFUser.current(){
            if let image = bannerView.image {
                user["banner"] = Event.getPFFileFromImage(image: image)
            }
            if let image2 = profileImageView.image {
                user["profile_image"] = Event.getPFFileFromImage(image: image2)
            }
            
//            if missionTextView.text != "" {
//                user["mission"] = missionTextView.text
//            }
//            
//            if contactTextView.text != "" {
//                user["contact"] = contactTextView.text
//            }
//            
            user.saveInBackground()
            print("Succesful update")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("logout succesful")
                //PFUser.logOutInBackground()
                let main = UIStoryboard(name: "Main", bundle: nil)
                let logInScreen = main.instantiateInitialViewController()
                self.present(logInScreen!, animated: true, completion: nil)
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
