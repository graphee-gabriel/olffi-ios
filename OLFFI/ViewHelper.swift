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
}
