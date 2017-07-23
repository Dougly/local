//
//  AppDelegate.swift
//  Local
//
//  Created by Douglas Galante on 7/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var auth = Authentication()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = auth
        
        
        setWindowAndRootNavigationController()
        
        
        return true
    }
    
    func setWindowAndRootNavigationController() {
        window = UIWindow()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = main.instantiateViewController(withIdentifier: "initialNavController") as! UINavigationController
        auth.navController = navController
        
        let mainViewController: MTMainViewController = main.instantiateViewController(withIdentifier: "MTMainViewController") as! MTMainViewController
        let loginVC: LoginVC = main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        if Auth.auth().currentUser != nil {
            let controllers = [loginVC, mainViewController]
            navController.setViewControllers(controllers, animated: false)
        } else {
            navController.setViewControllers([loginVC], animated: false)
        }
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:])
        -> Bool {
            
            var handled = false
            
            if let urlScheme = url.scheme {
                
                if urlScheme == "com.googleusercontent.apps.220419844882-lmn0vung4u6ie0ra85r7d8108ep5lfrv" {
                    handled = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
                } else if urlScheme == "fb103939270288346" {
                    handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
                }
                
            }
            print("🔥🔥🔥 application handleOpenURL", url.scheme)
            
            return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("🔥🔥🔥 application handleOpenURL", url.scheme)
        
        var handled = false
        
        if let urlScheme = url.scheme {
            
            if urlScheme == "com.googleusercontent.apps.220419844882-lmn0vung4u6ie0ra85r7d8108ep5lfrv" {
                handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            } else if urlScheme == "fb103939270288346" {
                handled = SDKApplicationDelegate.shared.application(application, open: url)
            }
            
        }
        return handled
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
        MTSettings.shared().overwriteKeyWordsAccordingToDayTime()
        NotificationCenter.default.post(name: Constants.foreground, object: nil)
        NotificationCenter.default.post(name: Constants.keywordChanged, object: nil)
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


