//
//  WebAppViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 11/03/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit
import WebKit
import FBSDKLoginKit

class WebAppViewController: UIViewController, WKNavigationDelegate {
    
    //@IBOutlet weak var webView: UIWebView?
    
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    var webView: WKWebView?
    var webAppIsReady = false
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView?.navigationDelegate = self
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 48/255.0, green: 154/255.0, blue: 177/255.0, alpha: 0.0)
        
        if webView != nil {
            self.webViewContainer.addSubview(webView!)
            let url = getUrlWithCredentials()
            print(url)
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            webView?.addObserver(self, forKeyPath: "URL", options: .New, context: nil)
            viewActivityIndicator.hidden = false
            viewActivityIndicator.startAnimating()
            NotificationToken.send() { (error) in
                if (error) {
                    print("could not send notification token to server")
                } else {
                    print("sucessfully sent notification token to server")
                }
            }
        }
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "URL")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "URL" {
            if webView != nil {
                if let url = webView?.URL?.absoluteString {
                    if url.containsString("logout") {
                        logOut()
                    }
                }
            }
            
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if !webAppIsReady {
            webAppIsReady = true
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.viewLoading.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    self.viewActivityIndicator.stopAnimating()
                    self.viewLoading.hidden = true
                })
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Garranty full screen - Remove to make space for status bar
        if webView != nil {
            webView?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCredentials() -> String {
        if auth.tokenType == .NULL || auth.tokenValue.isEmpty {
            return ""
        }
        return "?token=" + auth.tokenValue + "&type=" + auth.tokenType.rawValue;
    }
    
    func getUrlWithCredentials() -> String {
        return "https://www.olffi.com/app" + getCredentials()
    }
    
    func logOut() {
        auth.logOut()
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
        
        self.presentViewController(loginViewController!, animated: true, completion: nil)
    }
}

