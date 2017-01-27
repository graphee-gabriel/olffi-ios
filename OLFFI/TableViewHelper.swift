//
//  TableViewHelper.swift
//  OLFFI
//
//  Created by Gabriel Morin on 27/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation

class TableViewHelper {
    
    class func showEmptyMessage(saying message:String, viewController:UITableViewController) {
        let view = UIView(frame: CGRect(x:0, y:0, width:viewController.view.bounds.size.width, height:viewController.view.bounds.size.height))
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:viewController.view.bounds.size.width, height:viewController.view.bounds.size.height))
        imageView.image = UIImage(named: "background")
        let messageLabel = UILabel(frame: CGRect(x:0, y:0, width:viewController.view.bounds.size.width, height:viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = Fonts.NORMAL_BOLD
        messageLabel.sizeToFit()
        messageLabel.center = viewController.view.center
        
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        view.bringSubview(toFront: messageLabel)
        
        viewController.tableView.backgroundView = view
        viewController.tableView.separatorStyle = .none
    }
    
    class func showBackground(viewController:UITableViewController) {
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:viewController.view.bounds.size.width, height:viewController.view.bounds.size.height))
        imageView.image = UIImage(named: "background")
        viewController.tableView.separatorStyle = .singleLine
        viewController.tableView.backgroundView = imageView
    }
}
