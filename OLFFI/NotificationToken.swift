//
//  NotificationToken.swift
//  OLFFI
//
//  Created by Gabriel Morin on 28/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import Alamofire
import Foundation
import Firebase

class NotificationToken {
    static let URL_NOTIFICATIONS = "https://www.olffi.com/api/token"
    
    static func send(token:String, completion: (error:Bool) -> Void) {
        Alamofire.request(.POST, URL_NOTIFICATIONS,
            
            parameters: [
                "type"  : "notification",
                "token" : token
            ])
            .authenticate(user: auth.tokenType.rawValue, password: auth.tokenValue)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                    
                case .Success:
                    completion(error: false)
                    
                case .Failure(let error):
                    completion(error: true)
                    print(error)
                }
        }
    }
    
    static func send(completion: (error:Bool) -> Void) {
        
        if let token = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(token)")
            if (auth.isLoggedIn()) {
                send(token) { (error) in
                    if (error) {
                        print("could not send notification token to server")
                    } else {
                        print("sucessfully sent notification token to server")
                    }
                    
                }
            }
        }
    }
}