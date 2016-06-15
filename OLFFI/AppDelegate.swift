//
//  AppDelegate.swift
//  OLFFI
//
//  Created by Gabriel Morin on 11/03/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Auth {
    var tokenType:TokenType = .NULL,
        tokenValue = ""
    
    enum TokenType: String {
        case
            NULL = "",
            FACEBOOK = "facebook",
            LINKEDIN = "linkedin",
            BASIC = "basic"
    }
    
    func isLoggedIn() -> Bool {
        return !tokenValue.isEmpty
    }
    
    mutating func logOut() {
        self.tokenType = .NULL
        self.tokenValue = ""
        FBSDKLoginManager().logOut()
        save()
    }

    mutating func logIn(type:TokenType, token:String) {
        self.tokenType = type
        self.tokenValue = token
        save()
    }

    func save() {
        NSUserDefaults.standardUserDefaults().setValue(tokenType.rawValue, forKey: "tokenType")
        NSUserDefaults.standardUserDefaults().setValue(tokenValue, forKey: "tokenValue")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    mutating func load() {
        if let
            tokenTypeRawValue = NSUserDefaults.standardUserDefaults().valueForKey("tokenType") as! String?,
            tokenValue = NSUserDefaults.standardUserDefaults().valueForKey("tokenValue") as! String?
        {
            self.tokenType = TokenType(rawValue: tokenTypeRawValue)!
            self.tokenValue = tokenValue
        }
        print("load with tokenType: "+self.tokenType.rawValue + " | and tokenValue: "+self.tokenValue)
    }
}

var auth = Auth.init()

func startWebApp(currentViewController:UIViewController) {
    let webAppViewController = currentViewController.storyboard!.instantiateViewControllerWithIdentifier("WebAppViewController") as? WebAppViewController
    webAppViewController?.modalPresentationStyle = .Custom
    webAppViewController?.modalTransitionStyle = .CrossDissolve
    currentViewController.presentViewController(webAppViewController!, animated: true, completion: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if LISDKCallbackHandler.shouldHandleUrl(url) {
            return LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
//        let fbAccessToken = FBSDKAccessToken.currentAccessToken()
//        if (fbAccessToken != nil) {
//            auth.tokenType = .FACEBOOK
//            auth.tokenValue = fbAccessToken.tokenString
//        }
//        
//        if LISDKSessionManager.hasValidSession() && LISDKSessionManager.sharedInstance().session.accessToken != nil{
//            auth.tokenType = .LINKEDIN
//            auth.tokenValue = LISDKSessionManager.sharedInstance().session.accessToken.accessTokenValue
//        }
        auth.load()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier(auth.isLoggedIn() ? "WebAppViewController" : "LoginViewController")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

