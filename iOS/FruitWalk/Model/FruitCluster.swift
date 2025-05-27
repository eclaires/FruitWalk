//
//  Cluster.swift
//  FruitWalk
//
//  Created by Claire S on 2/26/25.
//
/**
 {
     "lng": -122.65851112593352,
     "lat": 38.23234101717651,
     "count": 1
 }
 */

import Foundation

struct FruitCluster : Identifiable, Codable, Equatable {
    var id = UUID()
    
    let latitude: Double
    let longitude: Double
    let count:  Int
    
    // identify which properties are codable
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case count
    }
}
    

