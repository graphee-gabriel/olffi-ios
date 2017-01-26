//
//  MenuViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 09/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarLogo()
        NotificationToken.send() { (error) in
            if (error) {
                print("could not send notification token to server")
            } else {
                print("sucessfully sent notification token to server")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressedButtonSettings(_ sender: UIBarButtonItem) {
    }
    func setupNavigationBarLogo() {
        
        let titleView = UIView(frame: CGRect(x:0, y:0, width:90, height:30))
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.frame = CGRect(x:0, y:0, width:titleView.frame.width, height:titleView.frame.height)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
        if let nav = self.navigationController {
            nav.navigationBar.barTintColor = UIColor(red: 251.0/255.0, green: 238.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            nav.navigationBar.tintColor = UIColor.black
        }
        
        
        print("logo image loaded")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var relativeUrl:String?
        print("prepare for segue")
        if let identifier = segue.identifier {
            print("identifier: \(identifier)")
            
            switch identifier {
            case "goto_calendar":
                relativeUrl = "/program/calendar.html"
            case "goto_publication":
                relativeUrl = "/publication.html"
            case "goto_compare":
                relativeUrl = "/program/compare.html"
            case "goto_settings":
                relativeUrl = "/account.html"
            default:
                break
            }
            
            if relativeUrl != nil {
                let controller = segue.destination as! WebViewController
                controller.url = UrlBuilder.buildUrl(from: relativeUrl!)
            }
            
        }
    }
}
