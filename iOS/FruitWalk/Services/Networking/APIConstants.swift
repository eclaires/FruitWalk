//
//  APIConstants.swift
//  FruitWalk
//
//  Created by Claire S on 6/26/25.
//

import Foundation

// api returns clusters when zoom is < 14
let LOCATION_ZOOM = 14

struct URLS {
    static let base = "https://beta.fallingfruit.org"
    static let api = "api/0.3/"
    static let locations = api + "locations"
    static let clusters = api + "clusters"
    static let types = api + "types"
}

struct Query {
    static let apiKey = "api_key"
    static let apiValue = "AKDJGHSD"
    static let boundsKey = "bounds"
    static let localeKey = "locale"
    static let localeValue = "en"
    static let limitKey = "limit"
    static let limitValue = "300"
    static let muniKey = "muni"
    static let muniValue = "true"
    static let zoomKey = "zoom"
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
