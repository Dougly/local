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

// will potentialy use this for all auth logic

class Authentication: NSObject, GIDSignInDelegate {
    
    var navController: UINavigationController?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("🔥🔥🔥 sign in error: \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("🔥🔥🔥 auth error: \(error)")
                return
            }
            
            DispatchQueue.main.async {
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
            let main = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController: MTMainViewController = main.instantiateViewController(withIdentifier: "MTMainViewController") as! MTMainViewController
            navController.pushViewController(mainViewController, animated: true)
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            //TODO: present alert so user knows they were not signed out
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
}
