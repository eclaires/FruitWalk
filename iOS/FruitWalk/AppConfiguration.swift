//
//  AppConfiguration.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation

let Locations_URL_Beta = "https://beta.fallingfruit.org/api/0.3/locations"
let Clusters_URL_Beta = "https://beta.fallingfruit.org/api/0.3/clusters"

// api returns clusters when zoom is < 15
let LOCATION_ZOOM = 15

struct requestConstants {
    static let locations_url = "https://beta.fallingfruit.org/api/0.3/locations"
    static let clusters_url = "https://beta.fallingfruit.org/api/0.3/clusters"
    static let api_key = "AKDJGHSD"
    static let locale = "en"
    static let muni = "true"
    static let limit = "300"
}

