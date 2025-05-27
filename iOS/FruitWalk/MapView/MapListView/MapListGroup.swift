//
//  MapListGroup.swift
//  FruitWalk
//
//  Created by Claire S on 5/21/25.
//

import Foundation

/// A grouping of `FruitLocation` items to be displayed in a List with expandable sections
struct MapListGroup : Identifiable {
    var id = UUID()
    
    let title: String
    let locations: [FruitLocation]
    var isExpanded = false
}
