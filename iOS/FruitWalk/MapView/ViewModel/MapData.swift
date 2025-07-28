//
//  MapData.swift
//  FruitWalk
//
//  Created by Claire S on 2/23/25.
//

import Foundation

struct MapData {
    var status: LoadingState
    var locations: [FruitLocation]
    var clusters: [FruitCluster]
    var requestRegion: MapRegion?
}
