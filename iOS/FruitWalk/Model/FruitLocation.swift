//
//  FruitLocation.swift
//  FruitWalk
//
//  Created by Claire S on 2/18/25.
//

import Foundation

/* A location has the JSON format
 {
   "id": 42,
   "lat": 45.6789,
   "lng": -123.45678,
   "type_ids": [
     97,
     92
   ],
   "distance": 47.915,
   "photo": "string",
   "type_names": [
     "Apple",
     "Pear"
   ]
 }
 */

struct FruitLocation : Codable, Equatable, Hashable {
    var id = UUID()
    // server returned data
    private(set) var identifier: Int
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var typeIds:  [Int]
    private(set) var distance: Double?
    private(set) var photo: String?
    private(set) var typeNames: [String]?
    // app stored data
    var favorite: Bool = false
    
    // identifies which properties are codable
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case latitude = "lat"
        case longitude = "lng"
        case typeIds = "type_ids"
        case distance
        case photo
        case typeNames = "type_names"
    }
    
    var firstTypeId: Int {
        return typeIds.first ?? 0
    }
}


