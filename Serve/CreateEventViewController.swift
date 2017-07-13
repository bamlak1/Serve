//
//  CreateEventViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var initiatePostOutlet: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var expectedTasksTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var titletextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        expectedTasksTextView.delegate = self
        locationTextView.delegate = self
        dateTextView.delegate = self
        timeTextView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func initiateImageUpload(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        vc.sourceType = .photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func publishPressed(_ sender: Any) {
        print("publishEvent pressed")
        Event.postEvent(image: bannerImageView.image, title: titletextField.text, description: descriptionTextView.text, location: locationTextView.text, date: dateTextView.text, time: timeTextView.text, jobs: expectedTasksTextView.text) { (success: Bool, error: Error?) in
            if success {
                print("Event created")
            } else {
                print(error?.localizedDescription ?? "error")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            locationTextView.resignFirstResponder()
            expectedTasksTextView.resignFirstResponder()
            dateTextView.resignFirstResponder()
            timeTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        bannerImageView.image = editedImage
        initiatePostOutlet.setTitle("", for: .normal)
        dismiss(animated: true , completion: nil)
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
