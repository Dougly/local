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
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // Signout code
    /*
     let firebaseAuth = Auth.auth()
     do {
     try firebaseAuth.signOut()
     } catch let signOutError as NSError {
     print ("Error signing out: %@", signOutError)
     }
     */
}
