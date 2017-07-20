//
//  CreateCauseViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit

class CreateCauseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = editedImage
        dismiss(animated: true , completion: nil)
    }
    
    
    
    @IBAction func createCause(_ sender: Any) {
        print("createCause pressed")
        Cause.createCause(name: nameTextField.text, image: imageView.image ) { (success: Bool, error: Error?) in
            if success {
                print("Cause created")
            } else {
                print(error?.localizedDescription ?? "error")
            }
            self.dismiss(animated: true, completion: nil)
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
