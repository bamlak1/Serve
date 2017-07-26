//
//  MapSettingsViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 7/20/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//
import UIKit

protocol SettingsDelegate {
    func drawHomeCircle(miles: Int)
    func updateDisplayedEvents(eventType: String, display: Bool)
}

class MapSettingsViewController: UIViewController {
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var myEventsSwitch: UISwitch!
    @IBOutlet weak var otherEventsSwitch: UISwitch!
    var sliderValue: Int!
    var delegate: SettingsDelegate?
    @IBOutlet weak var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        sliderValue = Int(UserDefaults.standard.float(forKey: "slider_value"))
        myEventsSwitch.isOn = UserDefaults.standard.bool(forKey: "mySwitchState")
        otherEventsSwitch.isOn = UserDefaults.standard.bool(forKey: "otherSwitchState")
        radiusSlider.value = Float(sliderValue)
        radiusLabel.text = String(sliderValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // When the user presses the close button, hides the settings menu
    // Redraws the circle using the appropriate radius
    @IBAction func closeSettings(_ sender: Any) {
        self.removeAnimate()
        delegate?.drawHomeCircle(miles: sliderValue)
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
    
    // If the radius slider value is changed, updates the on-screen label
    @IBAction func changedRadius(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "slider_value")
        sliderValue = Int(sender.value)
        let distanceString = String(sliderValue)
        radiusLabel.text = "\(distanceString)"
    }

    // Depending on whether the switch is active or not, displays what events the user has signed up and been accepted to
    @IBAction func switchMyEvents(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "mySwitchState")
        if myEventsSwitch.isOn {
            delegate?.updateDisplayedEvents(eventType: "userEvents", display: true)
        } else {
            delegate?.updateDisplayedEvents(eventType: "userEvents", display: false)
        }
    }
    
    // Depending on whether the switch is active or not, displays what events the user has not signed up/been accepted to
    @IBAction func switchOtherEvents(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "otherSwitchState")
        if otherEventsSwitch.isOn {
            delegate?.updateDisplayedEvents(eventType: "otherEvents", display: true)
        } else {
            delegate?.updateDisplayedEvents(eventType: "otherEvents", display: false)
        }
    }
    
    // If a user clicks on the background behind the settings menu, then the settings menu will be dismissed
    // Redraws the circle using the appropriate radius
    @IBAction func dismissSettings(_ sender: Any) {
        removeAnimate()
        delegate?.drawHomeCircle(miles: sliderValue)
    }
    
    // Gets rid of the settings menu using a gradual animation
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
