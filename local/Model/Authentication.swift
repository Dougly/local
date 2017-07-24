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


class Authentication: NSObject, GIDSignInDelegate {
    
    var navController: UINavigationController?
    
    
    // MARK: Google Auth
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("🔥🔥🔥 google sign in error: \(error)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        authenticateForFirebase(with: credential)
    }
    

    // MARK: Facebook Auth
    // login button logic called in LoginVC due to trailing closure errors when called here.
    func loginButtonDidCompleteLogin(_ result: LoginResult) {
        let accessToken = AccessToken.current
        guard let authToken = accessToken?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        authenticateForFirebase(with: credential)
    }
    
    
    // MARK: Firebase Auth
    func authenticateForFirebase(with credential: AuthCredential) {
        guard let navController = self.navController else { return }
        if let loginVC = navController.viewControllers[0] as? LoginVC {
            loginVC.activityIndicator.startAnimating()
            Auth.auth().signIn(with: credential) { (user, error) in
                loginVC.activityIndicator.stopAnimating()
                if let error = error {
                    loginVC.presentAlertfor(errorMessage: error.localizedDescription)
                    return
                }
                loginVC.presentMainVC()
            }
        }
    }
    
    
    // TODO: Add AuthType as a param to specify behavior based on what service they authenticated with
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
    
    
}
