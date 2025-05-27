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
    
    var data = MapData(locations: [FruitLocation](), clusters: [FruitCluster](), identifier: MapRequestId())
    
    @ObservationIgnored private let session: URLSession!
    @ObservationIgnored private let decoder = JSONDecoder()
    
    // create a data manager to decide how to cache...
    @ObservationIgnored private var cache = MapDataCache()

    @ObservationIgnored private var mapRequestId: MapRequestId?
    
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
    
    func fetchLocationDetails(for: FruitLocation) -> LocationDetails? {
        
        return nil
    }
    
    private func loadFriutLocations(for region: MapRegion) async {
        print("THREAD loadFriutLocations: " + String(cString: __dispatch_queue_get_label(nil)))
        if checkIfLoadingOrLoaded(for: region) {
            return
        }
        
        let searchRegion = region.multiplyBy(screenMultiplier: 1.5)
        
        // build the request identifier before any async call
        // the requiest identifier is used if the same request is made before the first returns
        let url = buildLocationsRequestURL(bounds: searchRegion.bounds)
        let mapRequestIdentifier = MapRequestId(zoom: Int(searchRegion.zoom), bounds: searchRegion.bounds)
        self.mapRequestId = mapRequestIdentifier
        
        do {
            if let data = await cache.getLocations(forCoordinates: region.bounds, at: region.zoom) {
                print("    ---- SETTING cached Locations and RETURN")
                // create a request identifier for what this data represents
                let identifier = MapRequestId(zoom: Int(searchRegion.zoom), bounds: data.bounds)
                self.data = MapData(locations: data.locations, clusters: [FruitCluster](), identifier: identifier)
                // not requesting after all
                self.mapRequestId = nil
                return
            }
            
            print("---- REQUESTING FRUIT!!! for zoom: \(searchRegion.zoom)")
            print("THREAD FruitStore.loadFriutLocations: " + String(cString: __dispatch_queue_get_label(nil)))
            
            let (data, response) = try await session.data(from: url)
            handleError(data, response)
            
            let fruitLocations = try decoder.decode([FruitLocation].self, from: data)
            // if we still want this data
            if self.mapRequestId == mapRequestIdentifier {
                print("    ---- SETTING FRUIT locations - count \(fruitLocations.count)")
                await cache.store(locations: fruitLocations, for: searchRegion.bounds, at: searchRegion.zoom )
                self.data = MapData(locations: fruitLocations, clusters: [FruitCluster](), identifier: mapRequestIdentifier)
                
                self.mapRequestId = nil
            } else {
                print("    ---- NOT ASSIGNING  and storing FRUIT")
            }
            
        } catch {
            print(error)
        }
    }
    
    private func loadFriutClusters(for region: MapRegion) async {
        if checkIfLoadingOrLoaded(for: region) {
            return
        }
        
        let searchRegion = region.multiplyBy(screenMultiplier: 2.0)
        
        // build the request identifier before any async call
        // the requiest identifier is used if the same request is made before the first returns
        let url = buildClustersRequest(bounds: searchRegion.bounds, zoom: Int(searchRegion.zoom))
        let mapRequestId = MapRequestId(zoom: Int(searchRegion.zoom), bounds: searchRegion.bounds)
        self.mapRequestId =  mapRequestId
        
        do {
            if let data = await cache.getClusters(for: region.bounds, at: Int(region.zoom)) {
                print("    ---- SETTING cached clusters and RETURN")
                // create a request identifier for what this data represents
                let identifier = MapRequestId(zoom: Int(searchRegion.zoom), bounds: data.bounds)
                self.data = MapData(locations: [FruitLocation](), clusters: data.clusters, identifier: identifier)
                // not requesting after all
                self.mapRequestId = nil
                return
            }
            
            print("---- REQUESTING CLUSTERS FOR zoom \(searchRegion.zoom)")
            
            let (data, response) = try await session.data(from: url)
            handleError(data, response)
            
            let clusters = try decoder.decode([FruitCluster].self, from: data)
            // if we still want this data set it in the observed variable
            if self.mapRequestId == mapRequestId {
                print("     ---- STORING AND SETTING CLUSTERS - count \(clusters.count)")
                await cache.store(clusters: clusters, within: searchRegion.bounds, at: searchRegion.zoom)
                self.data = MapData(locations: [FruitLocation](), clusters: clusters, identifier: mapRequestId)
                
                self.mapRequestId = nil
            } else {
                print("     ---- NOT ASSIGNING  and storing CLUSTERS")
            }
        } catch {
            print(error)
        }
    }
    
    private func buildLocationsRequestURL(bounds: MapBounds) -> URL {
        let bounds = "bounds=\(bounds.swLat),\(bounds.swLng)|\(bounds.neLat),\(bounds.neLng)"
        let urlString = Locations_URL_Beta + "?api_key=AKDJGHSD&locale=en&muni=true&limit=300&" + bounds
        let url = URL(string: urlString, encodingInvalidCharacters: true)
        return url!
    }
    
    private func buildClustersRequest(bounds: MapBounds, zoom: Int) -> URL {
        let bounds = "bounds=\(bounds.swLat),\(bounds.swLng)|\(bounds.neLat),\(bounds.neLng)"
        let urlString = Clusters_URL_Beta + "?api_key=AKDJGHSD&muni=true&zoom=\(zoom)&" + bounds
        let url = URL(string: urlString, encodingInvalidCharacters: true)
        return url!
    }
    
    private func getExpandedCoordinates(for region: MKCoordinateRegion, by kilometers: Double) -> MapBounds {
        let span = region.center.getLatLonSpan(distanceKm: kilometers)
        // Delta values represents the zoom level in the Web Mercator projection, where a smaller value indicates a higher zoom level.
        let mkSpan = MKCoordinateSpan(latitudeDelta: span.latitudeSpan, longitudeDelta: span.longitudeSpan)
        let expandedRegion = MKCoordinateRegion(center: region.center, span: mkSpan)
        return expandedRegion.bounds()
    }
    
    private func handleError(_ data: Data, _ response: URLResponse) {
        // check response code
        guard let httpResponse = response as? HTTPURLResponse else {
            print("not a HTTPURLResponse")
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            if let string = String(data: data, encoding: .utf8) {
                // {"error":"Zoom not in interval [0, 14]"}
                print(string)
            }
            return
        }
    }
    
    private func checkIfLoadingOrLoaded(for region: MapRegion) -> Bool {
        if let mapRequestId = self.mapRequestId, mapRequestId.requestsSameData(forZoom: region.zoom, withBounds: region.bounds) {
            print("    ---- RETURNING EARLY zoom \(region.zoom) already requested")
            return true
        }
        if data.identifier.requestsSameData(forZoom: Int(region.zoom), withBounds: region.bounds) {
            print("    ---- RETURNING EARLY zoom \(region.zoom) already returned")
            return true
        }
        return false
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

extension MapStore {
    
    func getLocationDetails(for identifier: Int) async -> (details: LocationDetails?, error: String?) {
        let urlString = "https://beta.fallingfruit.org/api/0.3/locations/" + String(identifier) + "?api_key=AKDJGHSD&embed=reviews"
        let url = URL(string: urlString)
        let configuration = URLSessionConfiguration.default
        let session  = URLSession.init(configuration: configuration)
        do {
            // TODO: test response
            let (data, response) = try await session.data(from: url!)
            let decoder = JSONDecoder()
            let details = try decoder.decode(LocationDetails.self, from: data)
            return(details, nil)
        } catch {
            print(error)
            // TODO: FIX ERROR
            return(nil, error.localizedDescription)
        }
    }
    
}


