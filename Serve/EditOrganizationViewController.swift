//
//  EditOrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class EditOrganizationViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var orgBannerView: UIImageView!
    @IBOutlet weak var contactTextView: UITextView!
    @IBOutlet weak var missionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTextView.delegate = self
        missionTextView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateImagePressed(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        vc.sourceType = .photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        orgBannerView.image = editedImage
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateButtonPressed(_ sender: Any) {
        if let user = PFUser.current(){
            if let image = orgBannerView.image {
                user["banner"] = Event.getPFFileFromImage(image: image)
            }
            
            if missionTextView.text != "" {
                user["mission"] = missionTextView.text
            }
            
            if contactTextView.text != "" {
                user["contact"] = contactTextView.text
            }
            
            user.saveInBackground()
            print("Succesful update")
        }
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
