//
//  BrowseViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/18/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var names = ["Bam", "Mikey", "Olga", "Others", "More others", "even others",]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var orgCollectionView: UICollectionView!
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        eventCollectionView.dataSource = self
        orgCollectionView.dataSource = self
        peopleCollectionView.dataSource = self
        eventCollectionView.delegate = self
        orgCollectionView.delegate = self
        peopleCollectionView.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "OrgCollectionViewCell", for: indexPath) as! OrgCollectionViewCell
        
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        
        let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "IndCollectionViewCell", for: indexPath) as! IndCollectionViewCell
        
        cell1.nameLabel.text = names[1]
        cell2.nameLabel.text = names[2]
        cell3.nameLabel.text = names[3]
        
        return cell1
        return cell3
        return cell2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
