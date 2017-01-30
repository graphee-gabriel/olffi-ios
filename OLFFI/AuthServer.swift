//
//  AuthServer.swift
//  OLFFI
//
//  Created by Gabriel Morin on 15/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//
import Alamofire
import Foundation

class AuthServer {
    static let URL_USER = "https://olffi.com/api/user"
    
    static func logIn(email:String, password:String, completion: @escaping (_ error:Bool) -> Void) {
        Alamofire.request(URL_USER, method:.get)
            .authenticate(user: email, password: password)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                //debugPrint(response)
                switch response.result {
                
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    let token = response.object(forKey: "token") as! String
                    auth.logIn(type: .BASIC, token: token)
                    completion(false)
                
                case .failure(let error):
                    completion(true)
                    print(error)
                }
        }
    }
    
    static func signUp(firstName:String, lastName:String, email:String, password:String,  completion: @escaping (_ error:Bool) -> Void) {
        Alamofire.request(URL_USER, method: .post,
            
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
                    
                case .success:
                    completion(false)
                    print("Validation Successful")
                    
                case .failure(let error):
                    
                    completion(true)
                    print(error)
                    
            }
        }
    }
    
    static func linkedIn(linkedinId:String, firstName:String, lastName:String, email:String, hash:String,  completion: @escaping (_ error:Bool) -> Void) {
        Alamofire.request(URL_USER, method: .post,
            
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
                
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    let token = response.object(forKey: "token") as! String
                    auth.logIn(type: .LINKEDIN, token: token)
                    completion(false)
                    
                case .failure(let error):
                    
                    completion(true)
                    print(error)
                    
            }
        }
    }
}
