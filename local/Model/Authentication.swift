//
//  Authentication.swift
//  Local
//
//  Created by Douglas Galante on 7/21/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FacebookCore

// will potentialy use this for all auth logic

enum AuthType {
    case Google, Facebook, Instagram
}

class Authentication: NSObject, GIDSignInDelegate {
    
    var navController: UINavigationController?
    
    
    // MARK: Google Authentication
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("🔥🔥🔥 sign in error: \(error)")
            return
        }
        
        if let loginVC = getLoginVC() {
            loginVC.activityIndicator.startAnimating()
            
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (user, error) in
                loginVC.activityIndicator.stopAnimating()
                if let error = error {
                    print("🔥🔥🔥 google auth error: \(error)")
                    return
                }
                self.presentMainVC()
            }
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func presentMainVC() {
        if let navController = self.navController {
            let loginVC = navController.viewControllers[0] as! LoginVC
            loginVC.presentMainVC()
        }
    }
    
    // TODO: Add AuthType as a param to specify behavior based on what ervice they authenticated with
    func signOut() {
        
        GIDSignIn.sharedInstance().disconnect()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            //TODO: present alert so user knows they were not signed out
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: Facebook Authentication
    func loginButtonDidCompleteLogin(_ result: LoginResult) {
        let accessToken = AccessToken.current
        guard let authToken = accessToken?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        
        
        if let loginVC = getLoginVC() {
            loginVC.activityIndicator.startAnimating()
            Auth.auth().signIn(with: credential) { (user, error) in
                loginVC.activityIndicator.stopAnimating()
                if let error = error {
                    print("🔥🔥🔥 fb auth error: \(error)")
                    loginVC.presentAlertfor(error: LoginError.emailUsedWithDifferentProvider)
                    return
                }
                self.presentMainVC()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    }
    
    func getLoginVC() -> LoginVC? {
        if let navController = self.navController {
            return navController.viewControllers[0] as! LoginVC
        }
        return nil
    }

    
}
