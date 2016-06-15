//
//  LoginViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 13/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var buttonFBLogin: FBSDKLoginButton!
    @IBOutlet var buttonLinkedInLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebook()
        buttonLinkedInLogin.layer.cornerRadius = 3
        buttonLinkedInLogin.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if auth.isLoggedIn() {
            startWebApp(self)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func onLinkedInLogin(sender: UIButton) {
        onLinkedInLogin()
    }
    
    func onLinkedInLogin() {
        LISDKSessionManager.createSessionWithAuth([LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            if LISDKSessionManager.hasValidSession() && LISDKSessionManager.sharedInstance().session.accessToken != nil {
                auth.logIn(.LINKEDIN, token: LISDKSessionManager.sharedInstance().session.accessToken.accessTokenValue)
            }
        }) { (error) -> Void in
            print("Error: \(error)")
        }
    }
    
    func configureFacebook() {
        buttonFBLogin.readPermissions = ["public_profile", "email"];
        buttonFBLogin.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            print("error")
        } else if (result.isCancelled) {
            print("result cancelled")
        } else {
            print("success logging")
            auth.logIn(.FACEBOOK, token: result.token.tokenString)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}
