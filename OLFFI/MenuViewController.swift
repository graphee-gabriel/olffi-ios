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
        print("------>>>>>> VIEW DID LOAD SERIOUSLY")
        super.viewDidLoad()
        print("------>>>>>> dam it dam it dam it")
        //setupNavigationBarLogo()
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
    
    func setupNavigationBarLogo() {
//        let logo = UIImage(named: "logo.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named:"logo"))
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
