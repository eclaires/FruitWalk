//
//  SearchResultItem.swift
//  FruitWalk
//
//  Created by Claire S on 4/25/25.
//

import Foundation
import MapKit

struct SearchResultItem: Identifiable, Hashable {
    let id = UUID()
    let identifier: Int?
    let title: String
    let subTitle: String
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
