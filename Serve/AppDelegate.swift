//
//  AppDelegate.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/10/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Serve"
                configuration.server = "https://immense-river-75750.herokuapp.com/parse"
            })
        )
        

        GMSServices.provideAPIKey("AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA")
        GMSPlacesClient.provideAPIKey("AIzaSyBCmydPROEO4zxGSnoB02DjRwIpejPgZjA")
        
        //FBSDKApplicationDelegate.sharedInstance().

        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    
        
        if let user = PFUser.current() {
            if user["type"] as! String == "Individual" {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Individual", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "IndividualInitialViewController") as! UITabBarController
                window?.rootViewController = vc
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "OrgStoryboard", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "OrgInitialViewController") as! UITabBarController
                window?.rootViewController = vc
            }
        }
        UserDefaults.standard.set(true, forKey: "userSwitchState")
        UserDefaults.standard.set(true, forKey: "otherSwitchState")
        UserDefaults.standard.set(1.0, forKey: "slider_value")
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

