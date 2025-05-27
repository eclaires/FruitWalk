//
//  CLLocationCoordinate2D+distance.swift
//  FruitWalk
//
//  Created by Claire S on 2/22/25.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D : @retroactive Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (fabs(lhs.latitude - rhs.latitude) <= .ulpOfOne) && (fabs(lhs.longitude - rhs.longitude) <= .ulpOfOne)
    }
    
    func approximateDistance(from start: CLLocationCoordinate2D) -> Double {
        let clStart = CLLocation(latitude: start.latitude, longitude: start.longitude)
        return clStart.distance(from: CLLocation(latitude: self.latitude, longitude: self.longitude))
    }
    
    func walkingDistance(from start: CLLocationCoordinate2D) async -> Double {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self))
        request.transportType = .walking
        
        let response = try? await MKDirections(request: request).calculate()
        if let route = response?.routes.first {
            return route.distance
        } else {
            return approximateDistance(from: start)
        }
    }
  
    func getLatLonSpan(distanceKm: Double) -> (latitudeSpan: Double, longitudeSpan: Double) {
        let earthRadiusKm: Double = 6371.0 // Radius of the Earth in kilometers
        
        // Calculate the change in latitude
        let latitudeSpan = distanceKm / earthRadiusKm * 180 / .pi
        
        // To calculate the longitude span, we need to take the latitude into account, since the length of a degree of longitude decreases as we move towards the poles
        let longitudeSpan = distanceKm / (earthRadiusKm * cos(latitude * .pi / 180)) * 180 / .pi
        
        return (latitudeSpan, longitudeSpan)
    }
    
}
