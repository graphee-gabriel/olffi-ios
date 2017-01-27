//
//  WebViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 23/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    var webView: WKWebView?
    var webAppIsReady = false
    var url = ""
    var titleCustom:String?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView?.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if titleCustom != nil {
            self.navigationItem.title = titleCustom!
        }
        
        if webView != nil {
            self.webViewContainer.addSubview(webView!)
            print("url to load: \(url)")
            _ = webView?.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
            webView?.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            viewActivityIndicator.isHidden = false
            viewActivityIndicator.startAnimating()
        }
        // Do any additional setup after loading the view.
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: "URL")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL" {
            if webView != nil {
                if let url = webView?.url?.absoluteString {
                    if url.range(of: "logout") != nil {
                        logOut()
                    }
                }
            }
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !webAppIsReady {
            webAppIsReady = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.viewLoading.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                self.viewActivityIndicator.stopAnimating()
                self.viewLoading.isHidden = true
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Garranty full screen - Remove to make space for status bar
        if webView != nil {
            webView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut() {
        auth.logOut()
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        self.present(loginViewController!, animated: true, completion: nil)
    }

}
