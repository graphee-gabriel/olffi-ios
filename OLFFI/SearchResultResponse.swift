//
//  SearchResult.swift
//  OLFFI
//
//  Created by Gabriel Morin on 18/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchResultResponse: Mappable {
    
    var hits: [SearchResultHit]!
    var page: Int!
    var nbHits: Int!
    var nbPages: Int!
    var query: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        hits <- map["hits"]
        page <- map["page"]
        nbHits <- map["nbHits"]
        nbPages <- map["nbPages"]
        query <- map["query"]
    }
}

struct SearchResultHit: Mappable {
    
    var program_name: String!
    var program_url: String!
    var country_name: String!
    var fb_name: String!
    var level: String!
    var nature_of_project: [String]!
    var project_type: [String]!
    var activity: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        program_name <- map["program_name"]
        program_url <- map["program_url"]
        country_name <- map["country_name"]
        fb_name <- map["fb_name"]
        level <- map["level"]
        nature_of_project <- map["nature_of_project"]
        project_type <- map["project_type"]
        activity <- map["activity"]
    }
}
