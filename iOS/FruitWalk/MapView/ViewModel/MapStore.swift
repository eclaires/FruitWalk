//
//  MapStore.swift
//  FruitWalk
//
//  Created by Claire S on 2/19/25.
//

import Foundation
import MapKit

/// A ViewData class responsible for fetching and caching fruit map data
/// Operates on the main actor to ensure UI consistency.
@MainActor @Observable class MapStore {
    
    // MARK: - Public State

    /// The latest loaded map data (locations, clusters, and the region they belong to).
    var data = MapData(status: .loading, locations: [], clusters: [], requestRegion: nil)

    // MARK: - Private Properties

    @ObservationIgnored private let session: URLSession
    @ObservationIgnored private let decoder = JSONDecoder()
    @ObservationIgnored private let cache = MapDataCache()
    @ObservationIgnored private var requestRegion: MapRegion?

    // MARK: - Initialization

    /// Initializes the store with a default URLSession configuration.
    init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Public Methods
    
    /// Fetches fruit data for the given map region.
    ///
    /// Chooses between loading clusters or individual fruit locations based on zoom level.
    /// - Parameter region: The map region to fetch data for.
    func fetchFruit(for region: MapRegion) async {
        if region.zoom < LOCATION_ZOOM {
            await loadFruitClusters(for: region)
        } else {
            await loadFruitLocations(for: region)
        }
    }
    
    /// Asynchronously fetches detailed information for a specific fruit location.
    ///
    /// - Parameter identifier: The unique ID of the fruit location.
    /// - Returns: A tuple containing the `LocationDetails` on success, or an error message string on failure.
    func getFruitLocationDetails(for identifier: Int) async -> (details: LocationDetails?, error: String?) {
        
        // Construct the request URL for the given fruit location ID
        let url = URLBuilder.buildLocationDetailsRequest(for: identifier)
        
        // Perform the API request and await the result, which can be either a success or failure
        let result: Result<LocationDetails, APIError> = await APIService.shared.request(
            url: url,
            responseType: LocationDetails.self
        )
        
        // Handle the result of the API request
        switch result {
        case .success(let details):
            // Return the fetched details with no error
            return (details, nil)
        case .failure(let error):
            // TODO: Integrate this error with UI feedback mechanisms
            // Return nil for details and the error message string
            return (nil, error.localizedDescription)
        }
    }

    /// Asynchronously Loads all fruit types from the API.
    func loadFruitTypes() async {
        let url = URLBuilder.buildFruitTypesRequest()
        let result: Result<[FruitType], APIError> = await APIService.shared.request(
            url: url,
            responseType: [FruitType].self
        )
        
        switch result {
        case .success(let types):
            print(types.count)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Private Methods
    
    /// Checks whether data for the specified region is already being loaded (self.requestRegion) or has been loaded (data.requestRegion)
    ///
    /// - Parameter region: The map region to check against current or past requests.
    /// - Returns: `true` if the region is already loading or loaded; otherwise, `false`.
    private func checkIfLoadingOrLoaded(for region: MapRegion) -> Bool {
        if let requestRegion = self.requestRegion ?? data.requestRegion, requestRegion.zoom == region.zoom, requestRegion.bounds.contains(region.bounds) {
            print("    ---- RETURNING EARLY zoom \(region.zoom) already requested or recieved")
            return true
        }
        return false
    }
    
    /// Asynchronously Loads fruit locations for a given map region
    ///
    /// This function uses caching and request deduplication to minimize redundant network calls.
    /// It also expands the search bounds to preload nearby clusters, improving map scrolling performance and user experience.
    ///
    /// - Parameter region: The map region for which to load fruit clusters.
    private func loadFruitLocations(for region: MapRegion) async {
        // Avoid loading if data for this region is already being loaded or has been loaded
        guard !checkIfLoadingOrLoaded(for: region) else { return }
        
        // Expand the search area slightly to anticipate nearby movements and reduce future loads
        let searchRegion = region.multiplyBy(screenMultiplier: 1.5)
        
        // Track the current requested region to validate response relevance later
        self.requestRegion = searchRegion

        // Helper closure to assign data and clear requestRegion
        func setData(_ locations: [FruitLocation], for region: MapRegion, isCached: Bool) {
            print("    ---- SETTING \(isCached ? "CACHED" : "NEW") \(locations.count) Fruit Locations")
            self.data = MapData(status: .loaded, locations: locations, clusters: [], requestRegion: region)
            self.requestRegion = nil
        }

        do {
            // Check cache for the expanded region first
            if let locations = await cache.getLocations(for: region.bounds, at: searchRegion.zoom) {
                setData(locations, for: searchRegion, isCached: true)
                return
            }
            
            // Then try the original region
            if let locations = await cache.getLocations(for: region.bounds, at: region.zoom) {
                setData(locations, for: region, isCached: true)
                return
            }

            // Build the URL and make a network request
            let url = URLBuilder.buildLocationsRequestURL(from: searchRegion)
            self.data.status = .loading
            
            print("---- REQUESTING FRUIT!!! for zoom: \(searchRegion.zoom), search size: \(searchRegion.size)")
            print("THREAD FruitStore.loadFriutLocations: " + String(cString: __dispatch_queue_get_label(nil)))

            let result: Result<[FruitLocation], APIError> = await APIService.shared.request(
                url: url,
                responseType: [FruitLocation].self
            )

            switch result {
            case .success(let fruitLocations):
                // Only assign data if the requested region is still valid
                if self.requestRegion == searchRegion {
                    await cache.store(locations: fruitLocations, for: searchRegion.bounds, at: searchRegion.zoom)
                    setData(fruitLocations, for: searchRegion, isCached: false)
                } else {
                    // Region changed before the result came back—do not update state
                    print("     ---- Fruit Locations RECEIVED DATA IGNORED (request changed)")
                }

            case .failure(let error):
                // TODO: Add better error handling if needed
                self.data.status = .failed(error)
                print(error)
            }
        }
    }
    
    /// Asynchronously Loads fruit clusters for a given map region
    ///
    /// This function uses caching and request deduplication to minimize redundant network calls.
    /// It also expands the search bounds to preload nearby clusters, improving map scrolling performance and user experience.
    ///
    /// - Parameter region: The map region for which to load fruit clusters.
    private func loadFruitClusters(for region: MapRegion) async {
        
        // Return early if we're already loading or have loaded this region
        guard !checkIfLoadingOrLoaded(for: region) else { return }

        // Expand the search area to improve caching hit rate
        let searchRegion = region.multiplyBy(screenMultiplier: 2.0)
        let url = URLBuilder.buildClustersRequest(from: searchRegion)
        
        // Save the request region to avoid duplicate requests
        self.requestRegion = searchRegion
        
        // Helper closure to assign data and clear requestRegion
        func setData(_ clusters: [FruitCluster], for region: MapRegion, isCached: Bool) {
            print("    ---- SETTING \(isCached ? "CACHED" : "NEW") Clusters")
            self.data = MapData(status: .loaded, locations: [], clusters: clusters, requestRegion: region)
            self.requestRegion = nil
        }

        do {
            // Check if clusters for the expanded region are cached
            if let clusters = await cache.getClusters(for: searchRegion.bounds, at: Int(searchRegion.zoom)) {
                setData(clusters, for: searchRegion, isCached: true)
                return
            }

            // Fallback: check if clusters for the original region are cached
            if let clusters = await cache.getClusters(for: region.bounds, at: Int(region.zoom)) {
                setData(clusters, for: region, isCached: true)
                return
            }

            print("---- REQUESTING CLUSTERS for zoom level \(searchRegion.zoom)")
            // Make the network request
            self.data.status = .loading
            let result: Result<[FruitCluster], APIError> = await APIService.shared.request(
                url: url,
                responseType: [FruitCluster].self
            )

            switch result {
            case .success(let fruitClusters):
                // Only assign data if the request region hasn't changed
                if self.requestRegion == searchRegion {
                    await cache.store(clusters: fruitClusters, within: searchRegion.bounds, at: searchRegion.zoom)
                    setData(fruitClusters, for: searchRegion, isCached: false)
                } else {
                    print("     ---- Cluster RECEIVED DATA IGNORED (request changed)")
                }

            case .failure(let error):
                // Handle error (should be forwarded to UI)
                print("     ---- ERROR loading clusters: \(error)")
                self.data.status = .failed(error)
            }
        }
    }
    
    
}



