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
    let SETTINGS_MAX_HITS_PER_PAGE = 400
    let SETTINGS_INDEX_CACHE_DURATION = 60000.0
    
    var index:Index?
    
    init() {
        index = buildIndex()
    }
    
    func buildIndex() -> Index {
        let client = Client(appID: APPLICATION_ID, apiKey: API_KEY)
        let index = client.index(withName: INDEX_NAME)

        index.searchCacheEnabled = true
        index.searchCacheExpiringTimeInterval = SETTINGS_INDEX_CACHE_DURATION

        return index
    }
    
    func search(for query:String, completionHandler: @escaping CompletionHandler) {
        let queryWithParameters = Query(query: query)
        queryWithParameters.setParameter(withName: "hitsPerPage", to: String(SETTINGS_MAX_HITS_PER_PAGE))
        index?.search(queryWithParameters, completionHandler: completionHandler)
    }
}
