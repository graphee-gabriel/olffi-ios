//
//  UrlBuilder.swift
//  OLFFI
//
//  Created by Gabriel Morin on 23/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation

class UrlBuilder {
    
    static func buildUrl(from relativeUrl:String) -> String {
        return appendCredentials(to: appendBaseUrl(to: relativeUrl))
    }
    
    static func buildCredentials() -> String {
        if auth.tokenType == .NULL || auth.tokenValue.isEmpty {
            return ""
        }
        return "token=\(auth.tokenValue)&type=\(auth.tokenType.rawValue)&app=ios";
    }
    
    static func appendBaseUrl(to relativeUrl:String) -> String {
        return "https://www.olffi.com" + relativeUrl
    }
    
    static func appendCredentials(to url:String) -> String {
        return url + "?" + buildCredentials()
    }
}
