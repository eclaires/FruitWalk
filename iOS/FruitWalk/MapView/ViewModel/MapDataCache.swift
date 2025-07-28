//
//  MapDataCache.swift
//  FruitWalk
//
//  Created by Claire S on 2/22/25.
//

import Foundation
import MapKit

/// Actor responsible for caching fruit locations and clusters data.
actor MapDataCache {
    
    /// Strongly-typed cache entry for either locations or clusters
    private enum CacheData {
        case locations([FruitLocation])
        case clusters([FruitCluster])
    }
    
    private struct CacheEntry {
        let bounds: MapBounds
        let data: CacheData
    }
    
    /// A dictionary with the key the zoom levels and value a tuple of map bounds and data (either fruit locations or clusters)
    private var cache: [Int: CacheEntry] = [:]
    
    /// Retrieves fruit locations if they exist and the bounds are valid
    func getLocations(for bounds: MapBounds, at zoom: Int) async -> [FruitLocation]? {
        if let entry = cache[zoom],
              entry.bounds.contains(bounds),
              case .locations(let locations) = entry.data {
            return locations
        }
        return nil
    }

    /// Retrieves fruit clusters if they exist and the bounds are valid
    func getClusters(for bounds: MapBounds, at zoom: Int) -> [FruitCluster]? {
        if let entry = cache[zoom],
              entry.bounds.contains(bounds),
              case .clusters(let clusters) = entry.data {
                return clusters
        }
        return nil
    }

    /// Stores a list of fruit locations in the cache
    func store(locations: [FruitLocation], for bounds: MapBounds, at zoom: Int) {
        cache[zoom] = CacheEntry(bounds: bounds, data: .locations(locations))
    }

    /// Stores a list of fruit clusters in the cache
    func store(clusters: [FruitCluster], within bounds: MapBounds, at zoom: Int) {
        cache[zoom] = CacheEntry(bounds: bounds, data: .clusters(clusters))
    }
    
}
