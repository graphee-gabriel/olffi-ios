//
//  BasicAuth.swift
//  OLFFI
//
//  Created by Gabriel Morin on 15/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//
import Alamofire
import Foundation

class BasicAuth {
    
    static func logIn(email:String, password:String, completion: (error:Bool) -> Void) {
        Alamofire.request(.GET, "https://olffi.com/api/user")
            .authenticate(user: email, password: password)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                //debugPrint(response)
                switch response.result {
                
                case .Success(let JSON):
                    let response = JSON as! NSDictionary
                    let token = response.objectForKey("token") as! String
                    auth.logIn(.BASIC, token: token)
                    completion(error: false)
                
                case .Failure(let error):
                    completion(error: true)
                    print(error)
                }
        }
        
    }
    
    static func signUp(firstName:String, lastName:String, email:String, password:String,  completion: (error:Bool) -> Void) {
        Alamofire.request(.POST, "https://olffi.com/api/user",
            
            parameters: [
                "first_name":                   firstName,
                "last_name":                    lastName,
                "user_email":                   email,
                "user_password":                password
            ])
            
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                    
                case .Success:
                    completion(error: false)
                    print("Validation Successful")
                    
                case .Failure(let error):
                    
                    completion(error: true)
                    print(error)
                    
                }
        }

    }
    
    static func linkedIn(linkedinId:String, firstName:String, lastName:String, email:String, hash:String,  completion: (error:Bool) -> Void) {
        Alamofire.request(.POST, "https://olffi.com/api/user",
            
            parameters: [
                "linkedin_id":                  linkedinId,
                "first_name":                   firstName,
                "last_name":                    lastName,
                "user_email":                   email,
                "hash":                         hash
            ])
            
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                
                case .Success(let JSON):
                    let response = JSON as! NSDictionary
                    let token = response.objectForKey("token") as! String
                    auth.logIn(.LINKEDIN, token: token)
                    completion(error: false)
                    
                case .Failure(let error):
                    
                    completion(error: true)
                    print(error)
                    
                }
        }
        
    }
}
