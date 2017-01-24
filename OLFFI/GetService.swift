//
//  GetService.swift
//  OLFFI
//
//  Created by Gabriel Morin on 24/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Alamofire
import Foundation
import AlamofireObjectMapper

class GetService {
    static let BASE_URL = "https://olffi.com/api/"
    static let PATH_COUNTRY = "country"
    static let PATH_COPRODUCTION_TREATY = "coproduction-treaty"
    
    static func countryList(email:String,
                            password:String,
                            completion: @escaping (_ countryList:[CountryResponse]) -> Void) {
        
        Alamofire.request(BASE_URL+PATH_COUNTRY, method:.get)
            .authenticate(user: email, password: password)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseArray { (response: DataResponse<[CountryResponse]>) in
                //debugPrint(response)
                completion(response.value!)
        }
    }
    
    static func coproductionTreatyList(email:String,
                                       password:String,
                                       completion: @escaping (_ coproductionTreatyList:[CoproductionTreatyResponse]) -> Void) {
        
        Alamofire.request(BASE_URL+PATH_COPRODUCTION_TREATY, method:.get)
            .authenticate(user: email, password: password)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseArray { (response: DataResponse<[CoproductionTreatyResponse]>) in
                //debugPrint(response)
                completion(response.value!)
        }
    }
}
