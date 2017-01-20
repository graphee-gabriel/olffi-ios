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
        print("dam it dam it dam it")
        setupNavigationBarLogo()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
