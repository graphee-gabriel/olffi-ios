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
    
    override func viewDidAppear(_ animated: Bool) {
        if auth.isLoggedIn() {
            startWebApp(currentViewController: self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func onLinkedInLogin(sender: UIButton) {
        onLinkedInLogin()
    }
    
    func onLinkedInLogin() {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            if LISDKSessionManager.hasValidSession() && LISDKSessionManager.sharedInstance().session.accessToken != nil {
                
                LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)", success: {
                    response in
                    //Do something with the response
                    print("data: "+(response?.data)!)
                    print("desc: "+response.debugDescription)
                    
                    let data = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        
//                        let parsed = json as NSDictionary
//                        let id = parsed.objectForKey("id") as! String
//                        let firstName = parsed.objectForKey("firstName") as! String
//                        let lastName = parsed.objectForKey("lastName") as! String
//
//                        let emailAddress = parsed.objectForKey("emailAddress") as! String
//                        
//                        let hash = (firstName+lastName+emailAddress+id+"FuckL1nk3dIN.com").md5
                        
                        
                        if (json["id"] as? String) != nil
                            && (json["firstName"] as? String) != nil
                            && (json["lastName"] as? String) != nil
                            && (json["emailAddress"] as? String) != nil
                        {
                            let id = json["id"] as! String
                            let firstName = json["firstName"] as! String
                            let lastName = json["lastName"] as! String
                            let emailAddress = json["emailAddress"] as! String
                            let hash = (firstName+lastName+emailAddress+id+"FuckL1nk3dIN.com").md5
                            AuthServer.linkedIn(linkedinId: id, firstName: firstName, lastName: lastName, email: emailAddress, hash: hash!, completion: { (error) in
                                if (error) {
                                    
                                } else {
                                    startWebApp(currentViewController: self)
                                }
                            })
                        }   
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    }, error: {
                        error in
                        //Do something with the error
                })
            }
        }) { (error) -> Void in
            print("Error: \(error)")
        }
    }
    
    func configureFacebook() {
        buttonFBLogin.readPermissions = ["public_profile", "email"];
        buttonFBLogin.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("error")
        } else if (result.isCancelled) {
            print("result cancelled")
        } else {
            print("success logging")
            auth.logIn(type: .FACEBOOK, token: result.token.tokenString)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}
