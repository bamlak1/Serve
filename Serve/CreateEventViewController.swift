//
//  CreateEventViewController.swift
//  Serve
//
//  Created by Michael Hamlett on 7/12/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import SwiftDate
import DateTimePicker
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Parse
import ParseUI

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate, GMSPlacePickerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CauseTVCellDelegate{
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var initiatePostOutlet: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var expectedTasksTextView: UITextView!
    @IBOutlet weak var titletextField: UITextField!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var startDate: NSDate?
    var endDate: NSDate?
    var causes : [PFObject] = []
    var filteredCauses : [PFObject] = []
    var addedCauses : [PFObject] = []
    var names : [String] = []
    
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MM/dd/YYYY hh:mm aa"
//    let date = Date()
//    startLabel.text = formatter.string(from: date)
//    endLabel.text = formatter.string(from: date)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        expectedTasksTextView.delegate = self
        
        tableView.dataSource = self
        searchBar.delegate = self
        fetchCauses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        locationButton.titleLabel!.text = ""
        locationLabel.text = place.formattedAddress
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress ?? "")")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    @IBAction func startDatePressed(_ sender: Any) {
        let picker = showDatePicker()
        picker.completionHandler = { date in
            self.startDate = date as! NSDate
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY hh:mm aa"
            self.startLabel.text = formatter.string(from: date)
        }
    }
    
  
    @IBAction func endDatePressed(_ sender: Any) {
        let picker = showDatePicker()
        picker.completionHandler = { date in
            self.endDate = date as! NSDate
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY hh:mm aa"
            self.endLabel.text = formatter.string(from: date)
        }
    }
    
    func showDatePicker() -> DateTimePicker{
        let min = Date()
        let picker = DateTimePicker.show(minimumDate: min)
        picker.highlightColor = UIColor(red: 120.0/255.0, green: 255.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false
        picker.is12HourFormat = true
        picker.dateFormat = "MM/dd/YYYY hh:mm aa"
        
        return picker
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
        Event.postEvent(image: bannerImageView.image, title: titletextField.text, description: descriptionTextView.text, location: locationLabel.text, startDate: startDate, start: startLabel.text, endDate: endDate, end: endLabel.text, jobs: expectedTasksTextView.text, causes: addedCauses, causeNames: names) { (success: Bool, error: Error?) in
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
            expectedTasksTextView.resignFirstResponder()
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    
    func fetchCauses(){
        let query = PFQuery(className: "Cause")
        
        query.findObjectsInBackground { (causes: [PFObject]?, error: Error?) in
            self.causes = causes!
            self.filteredCauses = causes!
            self.tableView.reloadData()
        }
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
