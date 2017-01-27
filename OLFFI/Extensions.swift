//
//  Extensions.swift
//  OLFFI
//
//  Created by Gabriel Morin on 25/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : Fonts.NORMAL_BOLD]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : Fonts.NORMAL]
        let normal =  NSAttributedString(string: text, attributes:attrs)
        self.append(normal)
        return self
    }
}
