//
//  MapDataCache.swift
//  FruitWalk
//
//  Created by Claire S on 2/22/25.
//

import Foundation
import MapKit

actor MapDataCache {
    
    private var cache = [Int: (bounds: MapBounds, data: [Any]) ]()
    
   func getLocations(forCoordinates bounds: MapBounds, at zoom: Int)  async -> (locations: [FruitLocation], bounds: MapBounds)? {
//       print("THREAD getLocations: " + String(cString: __dispatch_queue_get_label(nil)))
       if let stored = self.cache[zoom], let data = stored.data as? [FruitLocation], stored.bounds.contains(bounds) {
           return (data, stored.bounds)
       } else {
           // caching data we don't need
           self.cache[zoom] = nil
           return nil
       }
    }
    
    func getClusters(for bounds: MapBounds, at zoom: Int) -> (clusters: [FruitCluster], bounds: MapBounds)? {
        if let stored = self.cache[zoom], let data = stored.data as? [FruitCluster], stored.bounds.contains(bounds) {
            return (data, stored.bounds)
        } else {
            // caching data we don't need
            self.cache[zoom] = nil
            return nil
        }
    }
    
    // if the new data isn't within the current bounds remove all cached data
    func store(locations: [FruitLocation], for bounds : MapBounds, at zoom: Int) {
        self.cache[zoom] = (bounds, locations)
    }
    
    // if the new data isn't within the current bounds remove all cached data
    func store(clusters: [FruitCluster], within bounds: MapBounds, at zoom: Int) {
        self.cache[zoom] = (bounds, clusters)
    }
}
