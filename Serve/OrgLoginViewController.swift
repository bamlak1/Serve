//
//  OrgLoginViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/13/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class OrgLoginViewController: UIViewController, UICollectionViewDataSource {
    var causes = [Cause]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var organizationPhone: UITextField!
    @IBOutlet weak var organizationAddress: UITextField!
    @IBOutlet weak var causeInfoView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        fetchTopCauses()
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
        view.endEditing(true)
        causeInfoView.isHidden = true
    }
    
    @IBAction func didPressInfoButton(_ sender: Any) {
        causeInfoView.isHidden = !causeInfoView.isHidden
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return causes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CauseCell", for: indexPath) as! CauseCell
        cell.cause = causes[indexPath.item]
        if cell.isSelected == true {
            cell.backgroundColor = UIColor.orange
        } else {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }

    // Initializes different cause categories with a name and icon URL and adds them to the causes array
    func fetchTopCauses() {
        causes.append(Cause(name: "Children", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2016/240/iconmonstr-generation-4.png")! as URL))
        causes.append(Cause(name: "Education", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2017/240/iconmonstr-education-1.png")! as URL))
        causes.append(Cause(name: "Health", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-favorite-3.png")! as URL))
        causes.append(Cause(name: "Arts & Culture", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2017/240/iconmonstr-bank-1.png")! as URL))
        causes.append(Cause(name: "Seniors", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2016/240/iconmonstr-generation-16.png")! as URL))
        causes.append(Cause(name: "Human Rights", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-globe-5.png")! as URL))
        causes.append(Cause(name: "Homeless Outreach", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-home-10.png")! as URL))
        causes.append(Cause(name: "LGBT", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2013/240/iconmonstr-flag-3.png")! as URL))
        causes.append(Cause(name: "Other", iconUrl: NSURL(string: "https://cdns.iconmonstr.com/wp-content/assets/preview/2012/240/iconmonstr-help-3.png")! as URL))
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
