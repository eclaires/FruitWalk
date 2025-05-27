//
//  MapRequestId.swift
//  FruitWalk
//
//  Created by Claire S on 2/28/25.
//

import Foundation

struct MapRequestId: Equatable {
    
    let zoom: Int
    let bounds: MapBounds
    
    static func == (lhs: MapRequestId, rhs: MapRequestId) -> Bool {
        return lhs.bounds == rhs.bounds && lhs.zoom == rhs.zoom
    }
    
    init(zoom: Int, bounds: MapBounds) {
        self.zoom = zoom
        self.bounds = bounds
    }
    
    init() {
        self.zoom = 0
        self.bounds = MapBounds()
    }
    
    func requestsSameData(forZoom zoom: Int, withBounds corners: MapBounds) -> Bool {
        return (Int(self.zoom) == Int(zoom) && self.bounds.contains(corners))
    }
}
