//
//  OrgLoginViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit
import Parse

class OrgLoginViewController: UIViewController, UITextFieldDelegate {
    
    var causes : [PFObject] = []
    
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var organizationPhone: UITextField!
    @IBOutlet weak var organizationAddress: UITextField!
    @IBOutlet weak var causeInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.dataSource = self
        //self.collectionView.allowsMultipleSelection = true
        //fetchTopCauses()
        organizationPhone.delegate = self
        organizationAddress.delegate = self
        organizationName.delegate = self
        causeInfoView.isHidden = true
        // Do any additional setup after loading the view.
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
        organization.saveInBackground()
    }
    
    @IBAction func didPressView(_ sender: Any) {
        causeInfoView.isHidden = true
    }
    
    @IBAction func didPressInfoButton(_ sender: Any) {
        causeInfoView.isHidden = !causeInfoView.isHidden
    }
    
    @IBAction func causePressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Individual", bundle: nil).instantiateViewController(withIdentifier: "causePopUp") as! CausesPopUpViewController
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        organizationName.resignFirstResponder()
        organizationAddress.resignFirstResponder()
        organizationPhone.resignFirstResponder()
        return true
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
