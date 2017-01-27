//
//  ViewHelper.swift
//  OLFFI
//
//  Created by Gabriel Morin on 26/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation

class ViewHelper {
    static func buildLabelWith(title:String, text:String) -> NSMutableAttributedString {
        let formattedString = NSMutableAttributedString()
        return formattedString
            .bold("\(title): \n")
            .normal(text)
    }
    
    static func setupCornerRadius(for button:UIButton, to cornerRadius:CGFloat = CGFloat(3)) {
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
    }
    
    static func setupCornerRadius(for buttons:[UIButton], to cornerRadius:CGFloat = CGFloat(3)) {
        for button in buttons {
            setupCornerRadius(for: button)
        }
    }
}
