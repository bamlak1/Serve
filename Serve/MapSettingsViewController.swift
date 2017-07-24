//
//  MapSettingsViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit

class MapSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeSettings(_ sender: Any) {
        self.removeAnimate()
    }
    
    // Displays the settings menu such that the map view is shadowed, but can still be seen in the background
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // If a user clicks on the background behind the settings menu, then the settings menu will be dismissed
    @IBAction func dismissSettings(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func switchMyEvents(_ sender: Any) {
        
    }
    
    @IBAction func switchOtherEvents(_ sender: Any) {
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
