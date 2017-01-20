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
    let webAppViewController = currentViewController.storyboard!.instantiateViewController(withIdentifier:
        "MenuViewController") as? MenuViewController
    webAppViewController?.modalPresentationStyle = .custom
    webAppViewController?.modalTransitionStyle = .crossDissolve
    currentViewController.present(webAppViewController!, animated: true, completion: nil)
}

func startSignIn(currentViewController:UIViewController, modalTransitionStyle:UIModalTransitionStyle) {
    let signInViewController = currentViewController.storyboard!.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
    signInViewController?.modalPresentationStyle = .custom
    signInViewController?.modalTransitionStyle = modalTransitionStyle
    currentViewController.present(signInViewController!, animated: true, completion: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tokenRefreshNotificaiton),
            name: NSNotification.Name.firInstanceIDTokenRefresh,
            object: nil)
        
        auth.load()
        registerForPushNotifications(application: application)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if auth.isLoggedIn() {
            let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
            let navigationController = UINavigationController(rootViewController: vc)
            self.window!.rootViewController = navigationController
        } else {
            self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        

        
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        disconnectFromFcm()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0 
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

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
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

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        print("Device Token:", token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }

}

