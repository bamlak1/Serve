//
//  OrgLoginViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse

class OrgLoginViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CauseTVCellDelegate {
    
    var user = PFUser.current() {
        didSet{
            self.id = (user?.objectId)!
            print(self.id)
        }
    }
  
    var causes : [PFObject] = []
    var id : String?
    
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var organizationPhone: UITextField!
    @IBOutlet weak var organizationAddress: UITextField!
    @IBOutlet weak var causeInfoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var addedCauses : [PFObject] = []
    var filteredCauses: [PFObject] = []
    var names : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.dataSource = self
        //self.collectionView.allowsMultipleSelection = true
        //fetchTopCauses()
        tableView.dataSource = self
        tableView.delegate = self
        organizationPhone.delegate = self
        organizationAddress.delegate = self
        organizationName.delegate = self
        causeInfoView.isHidden = true
        fetchCauses()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setProperties(_ sender: Any) {
        let organization = PFUser.current()!
        organization["name"] = organizationName.text
        organization["phone"] = organizationPhone.text
        organization["address"] = organizationAddress.text
        user?.addUniqueObjects(from: addedCauses, forKey: "causes")
        user?.addUniqueObjects(from: names, forKey: "cause_names")
        organization.saveInBackground()
        
        
//        for cause in addedCauses{
//            cause.addUniqueObject(user, forKey: "users")
//            cause.saveInBackground()
//        }
    }
    
    @IBAction func didPressView(_ sender: Any) {
        causeInfoView.isHidden = true
    }
    
    @IBAction func didPressInfoButton(_ sender: Any) {
        causeInfoView.isHidden = !causeInfoView.isHidden
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        organizationName.resignFirstResponder()
        organizationAddress.resignFirstResponder()
        organizationPhone.resignFirstResponder()
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCauses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "causeTVcell") as! CauseTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        let cause = filteredCauses[indexPath.row]
        cell.cause = cause
        
        return cell
    }
    
    func didclickOnCellAtIndex(at index: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: index) as! CauseTableViewCell
        addedCauses.append(cell.cause!)
        let name = cell.nameLabel.text!
        names.append(name)
        
        
        print("button tapped at index:\(index)")
        print(self.addedCauses)
    }
    
    //SEARCH BAR FUNCTIONS
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCauses = searchText.isEmpty ? causes: causes.filter { (cause: PFObject) -> Bool in
            return(cause["name"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
        
    }
    
    func fetchCauses(){
        let query = PFQuery(className: "Cause")
        //query.whereKey("users", notEqualTo: (PFUser.current()?.objectId)!)
        
        query.findObjectsInBackground { (causes: [PFObject]?, error: Error?) in
            self.causes = causes!
            self.filteredCauses = causes!
            self.tableView.reloadData()
        }
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return causes.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CauseCell", for: indexPath) as! CauseCell
//        let cause = causes[indexPath.item]
//        cell.cause = cause
//        let name = cause["name"] as! String
//        
//        if let image = cause["image"] as? PFFile {
//            image.getDataInBackground { (data: Data?, error: Error?) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "error")
//                } else {
//                    let finalImage = UIImage(data: data!)
//                    cell.causeImageView.image = finalImage
//                }
//            }
//        }
//        
//        cell.causeName.text = name
//        
//        if cell.isSelected == true {
//            cell.backgroundColor = UIColor.orange
//        } else {
//            cell.backgroundColor = UIColor.clear
//        }
//        return cell
//    }
//    
//    // Initializes different cause categories with a name and icon URL and adds them to the causes array
//    func fetchTopCauses() {
//        let query = PFQuery(className: "Cause")
//        
//        query.findObjectsInBackground { (causes: [PFObject]?, error: Error?) in
//            self.causes = causes!
//            self.collectionView.reloadData()
//        }
//        
    
        
        
        
        //        causes.append(Cause(name: "Children", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2016/240/iconmonstr-generation-4.png")! as URL))
        //        causes.append(Cause(name: "Education", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2017/240/iconmonstr-education-1.png")! as URL))
        //        causes.append(Cause(name: "Health", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-favorite-3.png")! as URL))
        //        causes.append(Cause(name: "Arts & Culture", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2017/240/iconmonstr-bank-1.png")! as URL))
        //        causes.append(Cause(name: "Seniors", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2016/240/iconmonstr-generation-16.png")! as URL))
        //        causes.append(Cause(name: "Human Rights", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-globe-5.png")! as URL))
        //        causes.append(Cause(name: "Homeless Outreach", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-home-10.png")! as URL))
        //        causes.append(Cause(name: "LGBT", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2013/240/iconmonstr-flag-3.png")! as URL))
        //        causes.append(Cause(name: "Other", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-help-3.png")! as URL))
//    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
