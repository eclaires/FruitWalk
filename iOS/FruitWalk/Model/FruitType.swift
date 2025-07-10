//
//  FruitType.swift
//  FruitWalk
//
//  Created by Claire S on 5/28/25.
//

import Foundation
import SwiftData

/*
 {
     "id": 42,
     "created_at": "2014-06-19T01:02:03.456Z",
     "updated_at": "2014-07-20T12:34:56.789Z",
     "parent_id": 114,
     "pending": true,
     "scientific_names": [
       "Malus pumila",
       "Malus domestica",
       "Malus communis"
     ],
     "taxonomic_rank": 8,
     "common_names": {
       "ar": [
         "تفاح"
       ],
       "de": [
         "Apfel"
       ],
       "el": [
         "Μηλιά"
       ],
       "en": [
         "Apple",
         "Orchard apple",
         "Paradise apple"
       ]
     },
     "categories": [
       "forager"
     ],
     "urls": {
       "wikipedia": "https://en.wikipedia.org/wiki/Malus_domestica",
       "eat_the_weeds": "https://www.eattheweeds.com/apples-wild-crabapples"
     }
   }
 */

//TODO: which are optional?
struct FruitType: Codable, Equatable, Hashable {
    var id = UUID()

    private(set) var identifier: Int
    private(set) var parentId: Int?
    private(set) var pending: Bool
    private(set) var createdDate: String
    private(set) var updatedDate: String
    private(set) var taxonomicRank: String?
    private(set) var scientificNames: [String]
    private(set) var commonNames: [String]
    private(set) var urls: [String: URL]
    private(set) var categories: [String]
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case parentId = "parent_id"
        case pending
        case createdDate = "created_at"
        case updatedDate = "updated_at"
        case taxonomicRank = "taxonomic_rank"
        case scientificNames = "scientific_names"
        case commonNames = "common_names"
        case urls
        case categories = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        pending = try container.decode(Bool.self, forKey: .pending)
        createdDate = try container.decode(String.self, forKey: .createdDate)
        updatedDate = try container.decode(String.self, forKey: .updatedDate)
        taxonomicRank = try container.decodeIfPresent(String.self, forKey: .taxonomicRank)
        scientificNames = try container.decode([String].self, forKey: .scientificNames)
        urls = try container.decode([String: URL].self, forKey: .urls)
        categories = try container.decode([String].self, forKey: .categories)
        // common_names is localized, only save the english
        let names = try container.decode([String: [String]].self, forKey: .commonNames)
        commonNames = names["en"] ?? []
    }
}

/*
@Model
class FruitTypeData {
    @Attribute(.unique) var identifier: Int
    var parentId: Int?
    var pending: Bool
    var createdDate: String
    var updatedDate: String
    var taxonomicRank: String?
    var scientificNames: [String]
    var commonNames: [String: [String]]
    var urls: [String: URL]
    var categories: [String]
    
    init(identifier: Int, parentId: Int? = nil, pending: Bool, createdDate: String, updatedDate: String, taxonomicRank: String? = nil, scientificNames: [String], commonNames: [String : [String]], urls: [String : URL], categories: [String]) {
        self.identifier = identifier
        self.parentId = parentId
        self.pending = pending
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.taxonomicRank = taxonomicRank
        self.scientificNames = scientificNames
        self.commonNames = commonNames
        self.urls = urls
        self.categories = categories
    }
    
    convenience init(item: FruitType) {
        self.init(identifier: item.identifier, pending: item.pending, createdDate: item.createdDate, updatedDate: item.updatedDate, scientificNames: item.scientificNames, commonNames: item.commonNames, urls: item.urls, categories: item.categories)
    }
}

import SwiftUI

class FruitLookup {
    @Query private var types: [FruitTypeData]
    
    func findFruitType(by identifier: Int, parentId: Int) {
        _types = Query(filter: #Predicate { $0.identifier == identifier || (parentId != nil && $0.parentId == parentId)})
    }
}
*/
