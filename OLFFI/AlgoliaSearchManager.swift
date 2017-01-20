//
//  AlgoliaSearchManager.swift
//  OLFFI
//
//  Created by Gabriel Morin on 18/01/2017.
//  Copyright © 2017 Gabriel Morin. All rights reserved.
//

import Foundation
import AlgoliaSearch

class AlgoliaSearchManager {
    let APPLICATION_ID = "VJSPCUKOBC"
    let API_KEY = "68f4f23581880af2fb862ba0201e3c09"
    let INDEX_NAME = "Olffi_Programs"
    
    var index:Index?
    
    init() {
        index = buildIndex()
    }
    
    func buildIndex() -> Index {
        let client = Client(appID: APPLICATION_ID, apiKey: API_KEY)
        let index = client.index(withName: INDEX_NAME)
        return index
    }
    
    func search(forQuery query:String, completionHandler: @escaping CompletionHandler) {
        index?.search(Query(query: query), completionHandler: completionHandler)
    }
}
