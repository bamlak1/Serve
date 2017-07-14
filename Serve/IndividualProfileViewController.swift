//
//  IndividualProfileViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class IndividualProfileViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    //var user: User!
    var followingCounter: Int = 0
    var friendsCounter: Int = 0
    var userUpdates: [Update] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        //let user = PFUser.current()
        nameLabel.text = user["name"] as? String
        //interestsLabel.text = user["interests"]
        //find reference for banner image and profile pic
        followingCount.text = String(user["followingCounter"])
        friendsCount.text = String(user["friendsCounter"])
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
        profilePicImageView.clipsToBounds = true;
        
        fetchUserUpdates()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didAddFriend(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! PostCell
        
        cell.updates = userUpdates[indexPath.row]
        
        return cell
    }
    
    func fetchUserUpdates() {
        APIManager.shared.getUserUpdates { (updates, error) in
            if let updates = updates {
                self.userUpdates = updates
                self.profileTableView.reloadData()
            } else if let error = error {
                print("Error getting user's updates: " + error.localizedDescription)
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
