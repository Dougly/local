//
//  LoginVC.swift
//  Local
//
//  Created by Douglas Galante on 7/21/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin

class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var facebookSignInView: UIView!
    @IBOutlet weak var facebookSignInContainerView: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    var appManager: MTAppManager = MTAppManager.sharedInstance()
    var facebookEmail: String = ""
    var facebookID: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var name: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInButton.style = .wide
        // Attempt to sign in silently
        // GIDSignIn.sharedInstance().signIn()
        
        
        // Custom FB Login Button
        let facebookLoginTapGR = UITapGestureRecognizer(target: self, action: #selector(fbLoginButtonClicked))
        facebookSignInView.addGestureRecognizer(facebookLoginTapGR)
        facebookSignInView.layer.cornerRadius = 3
        facebookSignInView.layer.shadowColor = UIColor.black.cgColor
        facebookSignInView.layer.shadowOpacity = 0.6
        facebookSignInView.layer.shadowOffset = CGSize(width: 0, height: 1)
        facebookSignInView.layer.shadowRadius = 1
        
        

        
        
//        if let accessToken = AccessToken.current {
//            // User is logged in, use 'accessToken' here.
//        }
    }
    
    func fbLoginButtonClicked(_ sender: UITapGestureRecognizer) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.auth.loginButtonDidCompleteLogin(loginResult)
                print("Logged in!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonVisibility()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        checkIfSignedIn()
    }
    
    // Hide guest sign in button
    func updateButtonVisibility() {
        let dateToHide: String = "24 May 2017"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        let date: Date? = formatter.date(from: dateToHide)
        if let time = date?.timeIntervalSinceNow {
            if time < TimeInterval(0) {
                guestButton.isHidden = true
            }
        }
    }

    // TODO: This is not secure - should use keychain to save auth token. Although Using firebase should negate needing to save auth token
    // Check user defaults for saved auth token
    func checkIfSignedIn() {
        if (MTAppManager.sharedInstance().userAuthToken != nil) {
            showMainScreen()
        }
    }
    
    func showMainScreen() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController: MTMainViewController? = main.instantiateViewController(withIdentifier: "MTMainViewController") as? MTMainViewController
        navigationController?.pushViewController(mainViewController!, animated: true)
    }
 
    @IBAction func login(withFacebook sender: Any) {
//        facebookFacade.openSession(completionHandler: {() -> Void in
//            self.signUpWithFacebook()
//        }, andFailureBlock: {() -> Void in
//            self.facebookFacade.closeAndClearCache(true)
//        })
    }
    
//    @IBAction func login(withInstagram sender: Any) {
//        let main = UIStoryboard(name: "Main", bundle: nil)
//        let instagramViewController: MTInstagramViewController? = main.instantiateViewController(withIdentifier: "MTInstagramViewController") as? MTInstagramViewController
//        instagramViewController?.delegate = self
//        present(instagramViewController!, animated: true) { _ in }
//    }
    
    @IBAction func login(asGuest sender: Any) {
        showMainScreen()
    }
    
    
    // Will Be replaced with firebase fb auth
    
    func signUpWithFacebook() {
        print("Hit sign up with facebook")
     /*
        if facebookFacade.isSessionOpen() {
            facebookFacade.startRequestForMe(completionHandler: {(_ result: Any, _ error: Error?) -> Void in
                let facebookToken: String = self.facebookFacade.sessionAccessToken()
                facebookID = result[self.kId]
                facebookEmail = result[self.kEmail]
                firstName = result[self.kFirstName]
                lastName = result[self.kLastName]
                name = "\(firstName) \(lastName)"
                appManager.userAuthToken = facebookToken
                appManager.userName = name
                appManager.userEmail = facebookEmail
                appManager.facebookID = facebookID
                MTAppManager.sharedInstance.save()
                if appManager.userAuthToken {
                    self.showMainScreen()
                }
            })
        }
        else {
            
        }
 */
    }
    
    // MARK: - instagram delegate
//    func onAuthenticated(_ authToken: String) {
//        dismiss(animated: true, completion: {() -> Void in
//            self.appManager.userAuthToken = authToken
//            self.showMainScreen()
//        })
//    }

}


