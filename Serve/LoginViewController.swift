//
//  LoginViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/10/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse



class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emptyFieldAlert: UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the emptyFieldAlert
        emptyFieldAlert = UIAlertController(title: "Empty Field", message: "Fill in all text fields!", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        emptyFieldAlert.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSignIn(_ sender: Any) {
        //check to display error message if one of the field is empty
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            present(emptyFieldAlert, animated: true) { }
            return
        }
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                //let currentUser = user
                // display appropriate view controller after successful login based on which type of user logged in
                let typeOfUser = user?["type"] as! String
                if (typeOfUser == "individual"){
                    self.performSegue(withIdentifier: "userLogin", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "orgLogin", sender: nil)
                }
            }
        }
    }

    @IBAction func didPressSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signupSegue", sender: nil)
    }
    
  
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
