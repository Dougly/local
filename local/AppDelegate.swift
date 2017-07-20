//
//  AppDelegate.swift
//  Local
//
//  Created by Douglas Galante on 7/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit
//import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var facebookFacade = FacebookFacade.sharedInstance()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        facebookFacade?.application(application, didFinishLaunchingWithOptions: launchOptions ?? [UIApplicationLaunchOptionsKey : Any]())
        return true
    }
    
    // Facebook login -- Will be replaced with firebase facebook and instagram auth
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("🔥🔥🔥****** application handleOpenURL: %@", url)
        let handled: Bool? = facebookFacade?.application(app, open: url, options: options)
        return handled!
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("🚙****** 🚙application handleOpenURL: %@", url)
        let handled: Bool? = facebookFacade?.application(application, open: url, sourceApplication: sourceApplication ?? "", annotation: annotation)
        return handled!
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
        facebookFacade?.activateAppTrack()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        facebookFacade?.closeAndClearCache(true)
    }
    
}


