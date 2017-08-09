//
//  AppDelegate.swift
//  Serve
//
//  Created by Bamlak Gessessew on 7/10/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import UserNotifications
import Parse
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import ParseFacebookUtilsV4
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "serve"
                configuration.server = "https://damp-earth-64969.herokuapp.com/parse"
            })
        )
        
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(named: "green gradient.png"), for: UIBarMetrics.default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(red:0.06, green:0.69, blue:0.35, alpha:1.0)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor(red:0.02, green:0.33, blue:0.15, alpha:1.0)

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
        
        registerForPushNotifications()

        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            //let aps = notification["aps"] as! [String: AnyObject]
            //print(aps)
            let eventID = notification["eventId"] as! String
            
            //TODO: Segue to compose view
            let storyBoard = UIStoryboard(name: "Individual", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            vc.eventId = eventID
            vc.past = true
            
            let rootView = self.window?.rootViewController as? UITabBarController
            rootView?.selectedIndex = 2
            switch((rootView?.selectedIndex)!) {
            case 2:
                print("here")
                let navVC = rootView?.viewControllers?[2] as! UINavigationController
                navVC.pushViewController(vc, animated: true)
                break
            default:
                print("error presenting vc")
                break
            }
            
        }
        
        
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.delegate = self
        
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (accepted: Bool, error: Error?) in
            guard accepted == true else {
                print("User declined remote notifications")
                return
            }
            application.registerForRemoteNotifications()
        }

        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        //let aps = notification["aps"] as! [String: AnyObject]
        let eventID = notification["eventId"] as! String
        
        //TODO: Segue to compose view
        let storyBoard = UIStoryboard(name: "Individual", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        vc.eventId = eventID
        vc.past = true
        
        let rootView = self.window?.rootViewController as? UITabBarController
        rootView?.selectedIndex = 2
        switch((rootView?.selectedIndex)!) {
        case 2:
            print("here")
            let navVC = rootView?.viewControllers?[2] as! UINavigationController
            navVC.pushViewController(vc, animated: true)
            break
        default:
            print("error presenting vc")
            break
        }
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
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//        
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//        
        
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PFPush.handle(notification.request.content.userInfo)
        completionHandler(.alert)
    }
    
    
    
    
    
    //Device Token: bcbdf010aad00583bbf16545a3f093b5cb9496c6db72dd68ae3d2178db08cf21
}

