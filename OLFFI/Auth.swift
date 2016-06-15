//
//  Auth.swift
//  OLFFI
//
//  Created by Gabriel Morin on 15/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import FBSDKLoginKit

class Auth {
    var tokenType:TokenType = .NULL,
    tokenValue = ""
    
    enum TokenType: String {
        case
        NULL = "",
        FACEBOOK = "facebook",
        LINKEDIN = "linkedin",
        BASIC = "basic"
    }
    
    func isLoggedIn() -> Bool {
        return !tokenValue.isEmpty
    }
    
    func logOut() {
        self.tokenType = .NULL
        self.tokenValue = ""
        FBSDKLoginManager().logOut()
        save()
    }
    
    func logIn(type:TokenType, token:String) {
        self.tokenType = type
        self.tokenValue = token
        save()
    }
    
    func save() {
        NSUserDefaults.standardUserDefaults().setValue(tokenType.rawValue, forKey: "tokenType")
        NSUserDefaults.standardUserDefaults().setValue(tokenValue, forKey: "tokenValue")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func load() {
        if let
            tokenTypeRawValue = NSUserDefaults.standardUserDefaults().valueForKey("tokenType") as! String?,
            tokenValue = NSUserDefaults.standardUserDefaults().valueForKey("tokenValue") as! String?
        {
            self.tokenType = TokenType(rawValue: tokenTypeRawValue)!
            self.tokenValue = tokenValue
        }
    }
}