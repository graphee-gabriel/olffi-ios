//
//  AppDelegate.swift
//  OLFFI
//
//  Created by Gabriel Morin on 11/03/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

var auth = Auth.init()

func startWebApp(currentViewController:UIViewController) {
    let webAppViewController = currentViewController.storyboard!.instantiateViewControllerWithIdentifier("WebAppViewController") as? WebAppViewController
    webAppViewController?.modalPresentationStyle = .Custom
    webAppViewController?.modalTransitionStyle = .CrossDissolve
    currentViewController.presentViewController(webAppViewController!, animated: true, completion: nil)
}

func startSignIn(currentViewController:UIViewController, modalTransitionStyle:UIModalTransitionStyle) {
    let signInViewController = currentViewController.storyboard!.instantiateViewControllerWithIdentifier("SignInViewController") as? SignInViewController
    signInViewController?.modalPresentationStyle = .Custom
    signInViewController?.modalTransitionStyle = modalTransitionStyle
    currentViewController.presentViewController(signInViewController!, animated: true, completion: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(tokenRefreshNotificaiton),
            name: kFIRInstanceIDTokenRefreshNotification,
            object: nil)
        
        auth.load()
        registerForPushNotifications(application)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier(auth.isLoggedIn() ? "WebAppViewController" : "LoginViewController")
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
        disconnectFromFcm()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0 
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
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }

    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func disconnectFromFcm() {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    
    
    func tokenRefreshNotificaiton(notification: NSNotification) {
        //let refreshedToken = FIRInstanceID.instanceID().token()!
        //print("InstanceID token: \(refreshedToken)")
        NotificationToken.send() { (error) in
            if (error) {
                print("could not send notification token to server")
            } else {
                print("sucessfully sent notification token to server")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    
    
    
    //////////////////////////////////
    // REGISTER FOR NOTIFICATIONS IOS
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
}

