
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
        UserDefaults.standard.setValue(tokenType.rawValue, forKey: "tokenType")
        UserDefaults.standard.setValue(tokenValue, forKey: "tokenValue")
        UserDefaults.standard.synchronize()
    }

    func load() {
        if
            let tokenTypeRawValue = UserDefaults.standard.value(forKey: "tokenType") as! String?,
            let tokenValue = UserDefaults.standard.value(forKey: "tokenValue") as! String?
        {
            self.tokenType = TokenType(rawValue: tokenTypeRawValue)!
            self.tokenValue = tokenValue
        }
    }
}
