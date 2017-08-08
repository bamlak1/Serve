//
//  HighFiveViewController.swift
//  Serve
//
//  Created by Olga Andreeva on 8/7/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import SwiftGifOrigin

protocol HighFiveDelegate {
    func didPressFive(_ sender: UIButton)
}

class HighFiveViewController: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    var delegate: HighFiveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        gifView.image = UIImage.gif(name: "hands")
        let when = DispatchTime.now() + 2.7
        DispatchQueue.main.asyncAfter(deadline: when){
            self.removeAnimate()
        }
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
