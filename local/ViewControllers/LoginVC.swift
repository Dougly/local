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
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButton()
        setupFacebookButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonVisibility()
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
    
    
    // Bypass authentication with guest account for appStore Demo Account
    @IBAction func login(asGuest sender: Any) {
        presentMainVC()
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.thelocal.io/privacy-policy") {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setupFacebookButton() {
        let facebookLoginTapGR = UITapGestureRecognizer(target: self, action: #selector(fbLoginButtonTapped))
        facebookSignInView.addGestureRecognizer(facebookLoginTapGR)
        facebookSignInView.layer.cornerRadius = 3
        facebookSignInView.layer.shadowColor = UIColor.black.cgColor
        facebookSignInView.layer.shadowOpacity = 0.6
        facebookSignInView.layer.shadowOffset = CGSize(width: 0, height: 1)
        facebookSignInView.layer.shadowRadius = 1
    }
    
    
    func setupGoogleButton(){
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInButton.style = .wide
    }
    
    
    func fbLoginButtonTapped(_ sender: UITapGestureRecognizer) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success:
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.auth.loginButtonDidCompleteLogin(loginResult)
            }
        }
    }
    
    
    func presentMainVC() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController: MTMainViewController = main.instantiateViewController(withIdentifier: "MTMainViewController") as! MTMainViewController
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    
    func presentAlertfor(errorMessage: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    

}


