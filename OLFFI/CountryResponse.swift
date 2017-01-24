//
//  CountryResponse.swift
//  OLFFI
//
//  Created by Gabriel Morin on 20/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//


import Foundation
import ObjectMapper

struct CountryResponse: Mappable {
    
    var id: Int!
    var name: String!
    var code_iso: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code_iso <- map["code_iso"]
    }
}

