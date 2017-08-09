//
//  LoginViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/10/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import FacebookLogin
import FacebookCore
import ParseFacebookUtilsV4


class LoginViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emptyFieldAlert: UIAlertController!
    
    var name : String?
    var avi : PFFile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backView = UIImageView(frame: self.view.frame)
//        backView.image = UIImage(named: "main_1200")!
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = backView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backView.addSubview(blurEffectView)
//        
//        self.view.backgroundColor = UIColor(patternImage: backView.image!)
//       
        
        
        // Set up the emptyFieldAlert
        emptyFieldAlert = UIAlertController(title: "Empty Field", message: "Fill in all text fields!", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        emptyFieldAlert.addAction(cancelAction)
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        //animateBackground()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateBackground() {
        let backgroundImage = UIImage(named:"people.png")!
        let amountToKeepImageSquare = backgroundImage.size.height - self.view.frame.size.height
        
        // UIImageView 1
        let backgroundImageView1 = UIImageView(image: backgroundImage)
        backgroundImageView1.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.size.height)
        self.view.addSubview(backgroundImageView1)
        
        // UIImageView 2
        let backgroundImageView2 = UIImageView(image: backgroundImage)
        backgroundImageView2.frame = CGRect(x: backgroundImageView1.frame.size.width, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.height)
        self.view.addSubview(backgroundImageView2)
        
        // Animate background
        UIView.animate(withDuration: 6.0, delay: 0.0, options: [.repeat, .curveLinear], animations: {
            backgroundImageView1.frame = backgroundImageView1.frame.offsetBy(dx: -1 * backgroundImageView1.frame.size.width, dy: 0.0)
            backgroundImageView2.frame = backgroundImageView2.frame.offsetBy(dx: -1 * backgroundImageView2.frame.size.width, dy: 0.0)
        }, completion: nil)
        
        // Have something in the foreground look like its moving
        let square = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        square.frame.origin = CGPoint(x: self.view.frame.origin.x + 25, y: self.view.frame.size.height - 75)
        square.backgroundColor = UIColor.darkGray
        self.view.addSubview(square)
        
        // Animate foreground
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .curveLinear], animations: {
            square.transform = CGAffineTransform(rotationAngle: 33)
        }, completion: nil)
    }

    
    @IBAction func didPressView(_ sender: Any) {
        view.endEditing(true)
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
                if (typeOfUser == "Individual"){
                    self.performSegue(withIdentifier: "userLogin", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "orgLogin", sender: nil)
                }
            }
        }
    }
    
//    func loadData(){
//        let request: FBSDKGraphRequest = FBSDKGraphReques
//        request.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            if error == nil{
//                if let dict = result as? Dictionary<String, AnyObject>{
//                    let name:String = dict["name"] as AnyObject? as String
//                    let facebookID:String = dict["id"] as AnyObject? as String
//                    let email:String = dict["email"] as AnyObject? as String
//                    
//                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
//                    
//                    var URLRequest = NSURL(string: pictureURL)
//                    var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
//                    
//                    
//                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
//                        if error == nil {
//                            var picture = PFFile(data: data)
//                            PFUser.currentUser().setObject(picture, forKey: "profilePicture")
//                            PFUser.currentUser().saveInBackground()
//                        }
//                        else {
//                            println("Error: \(error.localizedDescription)")
//                        }
//                    })
//                    PFUser.currentUser().setValue(name, forKey: "username")
//                    PFUser.currentUser().setValue(email, forKey: "email")
//                    PFUser.currentUser().saveInBackground()
//                }
//            }
//        }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("ya")
        
        //let token = AccessToken.current
        
        var requestParam = ["fields": "id, email, name, picture"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParam)
        
        userDetails?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }
            if let result = result as? [String:Any] {
                print(result)
                let name = result["name"] as! String
                let id = result["id"] as! String
                
                let pictureURL = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"
                let url = URL(string: pictureURL)
                
                let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    if error == nil {
                        self.avi = PFFile(data: data!)
                        //PFUser.currentUser().setObject(picture, forKey: "profilePicture")
                        //PFUser.currentUser().saveInBackground()
                    }
                    else {
                        print("Error: \(error?.localizedDescription)")
                    }
                }
                task.resume()
                
//                NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: OperationQueue.mainQueue(), completionHandler: {(response: URLResponse!,data: NSData!, error: NSError!) -> Void in
//                    if error == nil {
//                        self.avi = PFFile(data: data)
//                        //PFUser.currentUser().setObject(picture, forKey: "profilePicture")
//                        //PFUser.currentUser().saveInBackground()
//                    }
//                    else {
//                        println("Error: \(error.localizedDescription)")
//                    }
//                })
                
                self.name = name
            }
        })
        
        PFFacebookUtils.logInInBackground(withReadPermissions: [ "public_profile", "email", "user_friends" ]) { (user: PFUser?, error: Error?) in
            if let user = user {
                if user.isNew {
                    print("new User")
                    
                    Following.createFollow( owner: (user.objectId)!) { (success: Bool, error: Error?) in
                        if success {
                            print("follow created")
                        } else {
                            print(error?.localizedDescription ?? "error")
                        }
                    }

                    
                    user["type"] = "Individual"
                    user["following"] = []
                    user["following_count"] = 0
                    user["causes"] = []
                    user["username"] = self.name
                    user["profile_image"] = self.avi
                    user["address"] = "777 Hamilton Ave. Menlo Park, CA 94025"
                    user.saveInBackground()
                    //self.performSegue(withIdentifier: "userLogin", sender: nil)
                } else {
                    print("logged in through fb")
                    self.performSegue(withIdentifier: "userLogin", sender: nil)
                }
            } else {
                print(error?.localizedDescription ?? "error")
            }
            
        }
        
        
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("no")
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
