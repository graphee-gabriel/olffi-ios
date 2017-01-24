//
//  CoproductionTreatyResponse.swift
//  OLFFI
//
//  Created by Gabriel Morin on 20/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//


import Foundation
import ObjectMapper

struct CoproductionTreatyResponse: Mappable {
    
    var id: Int!
    var sign_date: String!
    var in_force: String!
    var project_type: String!
    var countries_list: String!
    var url: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        sign_date <- map["sign_date"]
        in_force <- map["in_force"]
        project_type <- map["project_type"]
        countries_list <- map["countries_list"]
        url <- map["url"]
    }
}
