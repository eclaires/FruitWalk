//
//  LocationDetails.swift
//  FruitWalk
//
//  Created by Claire S on 3/3/25.
//

import Foundation

/**
 {
     "id": 1757043,
     "lat": 38.2282973,
     "lng": -122.64635269999997,
     "type_ids": [
         1
     ],
     "user_id": 16365,
     "author": "Rebeca Abrams",
     "import_id": null,
     "season_start": null,
     "season_stop": null,
     "access": 3,
     "description": null,
     "unverified": false,
     "created_at": "2019-05-08T22:32:03.536Z",
     "updated_at": "2019-05-08T22:32:03.536Z",
     "address": null,
     "city": "Petaluma",
     "state": "California",
     "country": "United States",
     "muni": false,
     "invasive": false,
     "reviews": [
         {
             "id": 39467,
             "location_id": 1757043,
             "user_id": 16365,
             "author": "Rebeca Abrams",
             "created_at": "2019-05-08T22:32:03.540Z",
             "updated_at": "2019-05-08T22:32:03.540Z",
             "observed_on": "2019-05-08",
             "comment": null,
             "fruiting": 1,
             "quality_rating": 2,
             "yield_rating": 1,
             "photos": []
         }
     ]
 }
 */

enum PropertyAccess: Int, Codable {
    case userOwned = 0          // Location is on my property.
    case ownerPermission = 1    // I have permission from the owner to add this Location.
    case publicLand = 2         // Location is on public land.
    case publicOverhang = 3     // Location is on private property but overhangs public property.
    case privateProperty = 4    // Location is on private property.
    
    func description() -> String {
        switch self {
            
        case .userOwned:
            return "Posted by a Falling Fruit User"
        case .ownerPermission:
            return "Owner permits access"
        case .publicLand:
            return "Located on public land"
        case .publicOverhang:
            return "Located on private property with public overhang"
        case .privateProperty:
            return "Warning: Located on private property"
        }
    }
}

struct LocationDetails : Identifiable, Codable, Equatable {
    var id = UUID()
    
    let identifier: Int
    let latitude: Double
    let longitude: Double
    let typeIds:  [Int]
    let address: String?
    let author: String?
    let description: String?
    let seasonStart: Int? // 0 based month of the year
    let seasonEnd: Int? // 0 based month of the year
    let access: PropertyAccess?
    let lastUpdate: String?
    let createdDate: String?
    
    // identify which properties are codable
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case latitude = "lat"
        case longitude = "lng"
        case typeIds = "type_ids"
        case seasonStart = "season_start"
        case seasonEnd = "season_stop"
        case author
        case address
        case description
        case access
        case createdDate = "created_at"
        case lastUpdate = "updated_at"
    }
}

extension LocationDetails {
    var fruitingDisplayString: String {
        if let startSeason = seasonStart, let endSeason = seasonEnd, startSeason >= 0 && startSeason < 12, endSeason >= 0 && endSeason < 12  {
            let start = DateFormatter().monthSymbols[startSeason]
            let end = DateFormatter().monthSymbols[endSeason]
            if startSeason == 0 && endSeason == 11 {
                return "Fruiting year round"
            } else {
                return("Fruiting from " + start + " to " + end)
            }
        }
        return ""
    }
}
