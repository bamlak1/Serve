//
//  EditOrganizationViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, GMSPlacePickerViewControllerDelegate {
    
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var editProfilePictureLabel: UILabel!
    @IBOutlet weak var editBannerLabel: UILabel!
    //Variable that is used to determine which imageview to fill when an image is selected
    var bannerPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioTextView.delegate = self
        bioTextView.text = "Add a bio to your profile"
        bioTextView.textColor = UIColor.lightGray
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
        editBannerLabel.text = ""
    }
    
    @IBAction func updateProfileImagePressed(_ sender: Any) {
        bannerPressed = false
        let vc2 = UIImagePickerController()
        vc2.delegate = self
        vc2.allowsEditing = true
        
        vc2.sourceType = UIImagePickerControllerSourceType.photoLibrary
        vc2.sourceType = .photoLibrary
        
        
        self.present(vc2, animated: true, completion: nil)
        editProfilePictureLabel.text = ""
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
            
            if bioTextView.text != "Add a bio to your profile" {
                user["bio"] = bioTextView.text
            }
            if locationLabel.text != ""{
                user["address"] = locationLabel.text
            }
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
    
    

    @IBAction func causesPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Individual", bundle: nil).instantiateViewController(withIdentifier: "causePopUp") as! CausesPopUpViewController
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            bioTextView.resignFirstResponder()
            return false
        }
        return true
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == UIColor.lightGray {
            bioTextView.text = nil
            bioTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text.isEmpty {
            bioTextView.text = "Add a bio to your profile"
            bioTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        locationButton.titleLabel!.text = ""
        locationLabel.text = place.formattedAddress
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress ?? "")")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
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
