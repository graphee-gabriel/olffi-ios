//
//  AppNavigation.swift
//  OLFFI
//
//  Created by Gabriel Morin on 23/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation

class AppNavigator {
    var originalViewController:UIViewController
    var storyboard:UIStoryboard
    var navigationController:UINavigationController
    
    init(from viewController:UIViewController) {
        self.originalViewController = viewController
        self.storyboard = viewController.storyboard!
        self.navigationController = viewController.navigationController!
    }
    
    func startWebApp(at url:String) {
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = url
        navigationController.pushViewController(vc, animated: true)
        //self.performSegueWithIdentifier("mySegue", sender:sender)
    }
}

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
