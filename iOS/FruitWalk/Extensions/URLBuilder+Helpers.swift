//
//  URLBuilder+Helpers.swift
//  FruitWalk
//
//  Created by Claire S on 6/26/25.
//

import Foundation

extension URLBuilder {
    
    /// Builds the URL used to request fruit locations
    /// - Parameter region: the MapRegion to retrieve fruit locations for
    /// - Returns: the URL for making the server request
    static func buildLocationsRequestURL(from region: MapRegion) -> URL {
        let bounds = "\(region.bounds.swLat),\(region.bounds.swLng)|\(region.bounds.neLat),\(region.bounds.neLng)"
    
        let url = URLBuilder(baseURL: URLS.base)
            .addPathComponent(URLS.locations)
            .addDefaultParameter()
            .addQueryParameter(key: Query.muniKey, value: Query.muniValue)
            .addQueryParameter(key: Query.limitKey, value: Query.limitValue)
            .addQueryParameter(key: Query.boundsKey, value: bounds)
            .addQueryParameter(key: Query.zoomKey, value: region.zoom.description)
            .build()
    
        return url!
    }
    
    /// Builds the URL used to request fruit clusters
    /// - Parameter region: the MapRegion to retrieve fruit cluster for
    /// - Returns: the URL for making the server request
    static func  buildClustersRequest(from region: MapRegion) -> URL {
        let bounds = "\(region.bounds.swLat),\(region.bounds.swLng)|\(region.bounds.neLat),\(region.bounds.neLng)"
    
        let url = URLBuilder(baseURL: URLS.base)
            .addPathComponent(URLS.clusters)
            .addDefaultParameter()
            .addQueryParameter(key: Query.muniKey, value: Query.muniValue)
            .addQueryParameter(key: Query.boundsKey, value: bounds)
            .addQueryParameter(key: Query.zoomKey, value: region.zoom.description)
            .build()
        
        return url!
    }
    
    /// Builds the URL used to request details about a fruit locaiton
    /// - Parameter identifier: the identifier to request details for
    /// - Returns: the URL for making the server request
    static func buildLocationDetailsRequest(for identifier: Int) -> URL {
        let url = URLBuilder(baseURL: URLS.base)
            .addPathComponent(URLS.locations)
            .addPathComponent(identifier.description)
            .addDefaultParameter()
            .build()
        
        return url!
    }
    
    /// Builds the URL used to request all fruit types in the system
    /// - Returns: the URL for making the server request
    static func buildFruitTypesRequest() -> URL {
        let url = URLBuilder(baseURL: URLS.base)
            .addPathComponent(URLS.locations)
            .addPathComponent(URLS.types)
            .addDefaultParameter()
            .build()
        
        return url!
    }
    
}
