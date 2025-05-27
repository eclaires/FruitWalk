//
//  MapBounds.swift
//  FruitWalk
//
//  Created by Claire S on 2/21/25.
//

import Foundation
import MapKit

struct MapBounds: Equatable {
    let swLat: Double
    let swLng: Double
    let neLat: Double
    let neLng: Double

    init() {
        swLat = 0.0
        swLng = 0.0
        neLat = 0.0
        neLng = 0.0
    }

    init(fromRegion region: MKCoordinateRegion) {
        swLat = (region.center.latitude - region.span.latitudeDelta / 2)//.roundToDecimal(3)
        swLng = (region.center.longitude - region.span.longitudeDelta / 2)//.roundToDecimal(3)
        neLat = (region.center.latitude + region.span.latitudeDelta / 2)//.roundToDecimal(3)
        neLng = (region.center.longitude + region.span.longitudeDelta / 2)//.roundToDecimal(3)
    }

    init(fromCenter center: CLLocationCoordinate2D, withSpan span: Double) {
        swLat = (center.latitude - span / 2)//.roundToDecimal(3)
        swLng = (center.longitude - span / 2)//.roundToDecimal(3)
        neLat = (center.latitude + span / 2)//.roundToDecimal(3)
        neLng = (center.longitude + span / 2)//.roundToDecimal(3)
    }
    
    init(fromCenter center: CLLocationCoordinate2D, withSpan span: MKCoordinateSpan) {
        swLat = (center.latitude - span.latitudeDelta / 2)//.roundToDecimal(3)
        swLng = (center.longitude - span.longitudeDelta / 2)//.roundToDecimal(3)
        neLat = (center.latitude + span.latitudeDelta / 2)//.roundToDecimal(3)
        neLng = (center.longitude + span.longitudeDelta / 2)//.roundToDecimal(3)
    }
    
    func contains(_ bounds: MapBounds) -> Bool {
        
        let isLatitudeInRange = bounds.swLat >= swLat && bounds.neLat <= neLat
        let isLongitudeInRange = bounds.swLng >= swLng && bounds.neLng <= neLng

        return isLatitudeInRange && isLongitudeInRange
    }
    
    func contains(_ location: CLLocationCoordinate2D) -> Bool {
        
        let isLatitudeInRange = location.latitude >= swLat && location.latitude <= neLat
        let isLongitudeInRange = location.longitude >= swLng && location.longitude <= neLng

        return isLatitudeInRange && isLongitudeInRange
    }
    
    func dimensions() -> String {
        return String(format:  "WIDTH %.2f HEIGHT %.2f", self.neLat - self.swLat, self.neLng - self.swLng)
    }
}
