//
//  CausesPopUpViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/24/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse

class CausesPopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CauseTVCellDelegate {
    
    var causes : [PFObject] = []
    var names : [String] = []
    var filteredCauses: [PFObject] = []
    var addedCauses: [PFObject] = []
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        fetchCauses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let name = cause["name"] as! String
        
        if let image = cause["image"] as? PFFile {
            image.getDataInBackground { (data: Data?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: data!)
                    cell.causeImageView.image = finalImage
                }
            }
        }
        cell.nameLabel.text = name
        
        return cell
    }
    
    
    func didclickOnCellAtIndex(at index: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: index) as! CauseTableViewCell
        addedCauses.append(cell.cause!)
        let name = cell.nameLabel.text as! String
        names.append(name)
        
        
        print("button tapped at index:\(index)")
        print(self.addedCauses)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let user = PFUser.current()
        user?.addUniqueObjects(from: addedCauses, forKey: "causes")
        user?.addUniqueObjects(from: names, forKey: "cause_names")
        user?.saveInBackground()
        
        for cause in addedCauses{
            cause.addUniqueObject(user!, forKey: "users")
            cause.saveInBackground()
        }
        
        removeAnimate()
    }
    
    func fetchCauses(){
        let query = PFQuery(className: "Cause")
        
        query.findObjectsInBackground { (causes: [PFObject]?, error: Error?) in
            self.causes = causes!
            self.filteredCauses = causes!
            self.tableView.reloadData()
        }
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        removeAnimate()
    }
    
    // Displays the settings menu such that the map view is shadowed, but can still be seen in the background
    //Shoutout to Olga
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    //SEARCH BAR FUNCTIONS
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCauses = searchText.isEmpty ? causes: causes.filter { (cause: PFObject) -> Bool in
            return(cause["name"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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
