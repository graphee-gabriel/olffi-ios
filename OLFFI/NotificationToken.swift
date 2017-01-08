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
    
    static func send(token:String, completion: @escaping (_ error:Bool) -> Void) {
        Alamofire.request(URL_NOTIFICATIONS, method: .post,
            
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
                    
                case .success:
                    completion(false)
                    
                case .failure(let error):
                    completion(true)
                    print(error)
                }
        }
    }
    
    static func send(completion: (_ error:Bool) -> Void) {
        
        if let token = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(token)")
            if (auth.isLoggedIn()) {
                send(token: token) { (error) in
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
