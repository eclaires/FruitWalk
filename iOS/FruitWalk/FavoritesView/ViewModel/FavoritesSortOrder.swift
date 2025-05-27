//
//  FavoritesSortOrder.swift
//  FruitWalk
//
//  Created by Claire S on 3/23/25.
//

import Foundation

enum FavoritesSortOrder: String, CaseIterable, Identifiable {
    case typeAZ
    case typeZA
    case distanceNearFar
    case distanceFarNear
    
    var id: Self { return self }
    
    var isDistanceSort:Bool {
        switch self {
        case .distanceNearFar,.distanceFarNear:
            return true
        default:
            return false
        }
    }
    
    var title: String {
        switch self {
         
        case .typeAZ:
            return "Fruit A-Z"
        case .typeZA:
            return "Fruit Z-A"
        case .distanceNearFar:
            return "Distance Near-Far"
        case .distanceFarNear:
            return "Distance Far-Near"
        }
    }
    
    static var defaultSort: FavoritesSortOrder {
        return .typeAZ
    }
}
