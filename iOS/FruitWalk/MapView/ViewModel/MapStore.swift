//
//  MapStore.swift
//  FruitWalk
//
//  Created by Claire S on 2/19/25.
//

import Foundation
import MapKit

//TODO: functions to build URL requests

@MainActor @Observable class MapStore {
    
    var data = MapData(locations: [FruitLocation](), clusters: [FruitCluster](), requestRegion: nil)
    
    @ObservationIgnored private let session: URLSession!
    @ObservationIgnored private let decoder = JSONDecoder()
    
    // create a data manager to decide how to cache...
    @ObservationIgnored private var cache = MapDataCache()
    // the reqion we are requesting data for
    @ObservationIgnored private var requestRegion: MapRegion?
    
    init() {
        let configuration = URLSessionConfiguration.default
        session  = URLSession.init(configuration: configuration)
    }

    func fetchFruit(for region: MapRegion) async {
        if region.zoom < LOCATION_ZOOM {
            await loadFriutClusters(for: region)
        } else {
            await loadFriutLocations(for: region)
        }
    }

    private func checkIfLoadingOrLoaded(for region: MapRegion) -> Bool {
        if let requestRegion = self.requestRegion, requestRegion.zoom == region.zoom, requestRegion.bounds.contains(region.bounds) {
            print("    ---- RETURNING EARLY zoom \(region.zoom) already REQUESTED")
            return true
        }
        if let requestRegion = data.requestRegion, requestRegion.zoom == region.zoom, requestRegion.bounds.contains(region.bounds) {
            print("    ---- RETURNING EARLY zoom \(region.zoom) already RETURNED")
            return true
        }
        return false
    }
    
    private func loadFriutLocations(for region: MapRegion) async {
        if checkIfLoadingOrLoaded(for: region) {
            return
        }
        
        let searchRegion = region.multiplyBy(screenMultiplier: 1.5)
        // set self.requestRegion before async cache lookup below in case checkIfLoadingOrLoaded above is called again
        self.requestRegion = searchRegion

        do {
            // first see if the expanded search region is cached, if not see if the requested region is cached
            if let data = await cache.getLocations(forCoordinates: region.bounds, at: searchRegion.zoom) {
                print("    ---- SETTING cached Locations for SEARCH REGION and RETURN")
                self.data = MapData(locations: data.locations, clusters: [FruitCluster](), requestRegion: searchRegion)
                self.requestRegion = nil
                return
            } else if let data = await cache.getLocations(forCoordinates: region.bounds, at: region.zoom) {
                print("    ---- SETTING cached Locations for Requested REGION and RETURN")
                self.data = MapData(locations: data.locations, clusters: [FruitCluster](), requestRegion: region)
                self.requestRegion = nil
                return
            }
            
            let url = URLBuilder.buildLocationsRequestURL(from: searchRegion)
            
            print("---- REQUESTING FRUIT!!! for zoom: \(searchRegion.zoom), search size: \(searchRegion.size)")
            print("THREAD FruitStore.loadFriutLocations: " + String(cString: __dispatch_queue_get_label(nil)))
            
            let result: Result<[FruitLocation], APIError> = await APIService.shared.request(
                url: url,
                responseType: [FruitLocation].self
            )
            
            switch result {
            case .success(let fruitLocations):
                // if we still want this data
                if self.requestRegion == searchRegion {
                    print("    ---- SETTING FRUIT locations - count \(fruitLocations.count)")
                    await cache.store(locations: fruitLocations, for: searchRegion.bounds, at: searchRegion.zoom )
                    self.data = MapData(locations: fruitLocations, clusters: [FruitCluster](), requestRegion: searchRegion)
                    
                    self.requestRegion = nil
                } else {
                    print("    ---- NOT ASSIGNING  and storing FRUIT")
                }
            case .failure(let error):
                // TODO: pass to the UI
                print(error)
            }
        }
    }
    
    private func loadFriutClusters(for region: MapRegion) async {
        if checkIfLoadingOrLoaded(for: region) {
            return
        }
        
        let searchRegion = region.multiplyBy(screenMultiplier: 2.0)
        
        // build the request identifier before any async call
        // the requiest identifier is used if the same request is made before the first returns
        let url = URLBuilder.buildClustersRequest(from: searchRegion)
        self.requestRegion = searchRegion
        
        do {
            // first see if the expanded search region is cached, if not see if the requested region is cached
            if let data = await cache.getClusters(for: searchRegion.bounds, at: Int(searchRegion.zoom)) {
                print("    ---- SETTING cached clusters and RETURN")
                self.data = MapData(locations: [FruitLocation](), clusters: data.clusters, requestRegion: searchRegion)
                // not requesting after all
                self.requestRegion = nil
                return
            } else if let data = await cache.getClusters(for: region.bounds, at: Int(region.zoom)) {
                print("    ---- SETTING cached clusters and RETURN")
                self.data = MapData(locations: [FruitLocation](), clusters: data.clusters, requestRegion: region)
                // not requesting after all
                self.requestRegion = nil
                return
            }
            
            print("---- REQUESTING CLUSTERS FOR zoom \(searchRegion.zoom)")
            let result: Result<[FruitCluster], APIError> = await APIService.shared.request(
                url: url,
                responseType: [FruitCluster].self
            )
            
            switch result {
            case .success(let fruitClusters):
                // if we still want this data set it in the observed variable
                if self.requestRegion == searchRegion {
                    print("     ---- STORING AND SETTING CLUSTERS - count \(fruitClusters.count)")
                    await cache.store(clusters: fruitClusters, within: searchRegion.bounds, at: searchRegion.zoom)
                    self.data = MapData(locations: [FruitLocation](), clusters: fruitClusters, requestRegion: searchRegion)
                    
                    self.requestRegion = nil
                } else {
                    print("     ---- NOT ASSIGNING  and storing CLUSTERS")
                }
            case .failure(let error):
                // TODO: pass to the UI
                print(error)
            }
        }
    }
    
    func getFruitLocationDetails(for identifier: Int) async -> (details: LocationDetails?, error: String?) {
        let url = URLBuilder.buildLocationDetailsRequest(for: identifier)
        let result: Result<LocationDetails, APIError> = await APIService.shared.request(
            url: url,
            responseType: LocationDetails.self
        )
        
        switch result {
        case .success(let details):
            return(details, nil)
        case .failure(let error):
            // TODO: pass to the UI
            return(nil, error.localizedDescription)
        }
    }

    /*
       public func loadTypes() async {
           let urlString = "https://beta.fallingfruit.org/api/0.3/types?api_key=AKDJGHSD"
           let url = URL(string: urlString)
           
               do {
                   
                   print("THREAD FruitStore.loadTypes: " + String(cString: __dispatch_queue_get_label(nil)))
                   
                   let (data, response) = try await session.data(from: url!)
                   types = try decoder.decode([FruitType].self, from: data)
               } catch {
                   print(error)
               }
       }
    */
}



