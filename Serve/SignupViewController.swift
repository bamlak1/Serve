//
//  SignupViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/11/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

enum UserType: String {
    case Individual = "Individual"
    case Organization = "Organization"
}

let userTypesDict : [String:UserType] = ["Individual": .Individual, "Organization": .Organization]

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var emptyFieldAlert: UIAlertController!
    var newUser = PFUser()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var userTypes = ["Individual", "Organization"]
    var selectedType = UserType.Individual
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        //check to display error message if one of the field is empty
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            present(emptyFieldAlert, animated: true) { }
            return
        }
        
        newUser.username = usernameTextField.text
        newUser.email = emailTextField.text
        newUser.password = passwordTextField.text
        
        switch self.selectedType {
        case .Individual:
            newUser["type"] = "Individual"
            newUser["following"] = []
            newUser["following_count"] = 0
            newUser["causes"] = []
            newUser["address"] = "777 Hamilton Ave. Menlo Park, CA 94025"
            


            //self.performSegue(withIdentifier: "loginIndivSegue", sender: nil)
        //Insert code to initialize individual properties
        case .Organization:
            newUser["type"] = "Organization"
            newUser["following"] = []
            newUser["following_count"] = 0
            newUser["causes"] = []

            self.dismiss(animated: false, completion: nil)
            //self.performSegue(withIdentifier: "loginOrgSegue", sender: nil)
            //Insert code to initialize organization properties
        }
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay, created a user!")
                
                Following.createFollow( owner: (self.newUser.objectId)!) { (success: Bool, error: Error?) in
                    if success {
                        print("follow created")
                    } else {
                        print(error?.localizedDescription ?? "error")
                    }
                }
                
//                PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) { (user: PFUser?, error: Error?) in
//                    if let error = error {
//                        print("User log in failed: \(error.localizedDescription)")
//                    } else {
//                        print("User logged in successfully")
//                    }
//                }
                
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
     
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTypeString = userTypes[row]
        selectedType = userTypesDict[selectedTypeString]!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
