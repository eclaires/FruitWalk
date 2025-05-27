//
//  MapRegion.swift
//  FruitWalk
//
//  Created by Claire S on 2/28/25.
//

import Foundation
import MapKit

/// MapRegion contains zoom and coordinates used to make requests to the server which requires Web Mercator format
/// It converts data from Apple Maps
struct MapRegion {
    let center: CLLocationCoordinate2D
    let zoom: Int
    let span: Double
    let size: CGSize
    let bounds: MapBounds
    
    func multiplyBy(screenMultiplier: Double) -> MapRegion {
        let size = CGSize(width: self.size.width * screenMultiplier, height: self.size.height * screenMultiplier)
        return MapRegion(center: self.center, viewSize: size, zoom: self.zoom)
    }
    
    /// Initializes the Web Mercator MapRegion using data from the Apple Map
    /// - Parameters:
    ///   - mkRegion: Apple's MKCoordinateRegion
    ///   - size: the size of the view displaying the map
    ///   - heading: the heading of the map
    init(mkRegion: MKCoordinateRegion, viewSize size: CGSize, heading: Double) {
        
        /// Conversion function to determine the Web Mercator zoom and span from the map heading and MKCoordinateSpan
        /// - Parameters:
        ///   - heading: the Map heading
        ///   - span: the Map MKCoordinateSpan
        /// - Returns: a touple of the converted mercator zoom and span
        func getZoomAndSpan(heading: Double, span: MKCoordinateSpan) -> (zoom: Double, span: Double) {
            var angleCamera = heading
            // normalize the map rotation angle to between 0–90°
            if angleCamera > 270 {
                angleCamera = 360 - angleCamera
            } else if angleCamera > 90 {
                angleCamera = fabs(angleCamera - 180)
            }
            // convert to radians
            let angleRad = Double.pi * angleCamera / 180
            
            let width = Double(size.width)
            let height = Double(size.height)
            // calculate the adjusted map span that accounts for the rotation of the map.
            let straightenedSpan = width * span.longitudeDelta / (width * cos(angleRad) + (height) * sin(angleRad))
            
            let zoom = log2((360.0 * width / 128.0) / straightenedSpan)

            return (zoom, straightenedSpan)
        }
        
        self.center = mkRegion.center
        self.size = size
        let dims = getZoomAndSpan(heading: heading, span: mkRegion.span)
        self.zoom = Int(dims.zoom.rounded())
        self.span = dims.span
        self.bounds = MapBounds.init(fromCenter: center, withSpan: span)
    }
    
    init(center: CLLocationCoordinate2D, viewSize size: CGSize, zoom: Int) {
        self.center = center
        self.zoom = zoom
        self.size = size
        
        let width = Double(size.width)
        
        // calculate the Web Mercator longitude span at a given zoom level.
        self.span = (360.0 * width) / (128.0 * pow(2.0, Double(zoom)))
        self.bounds = MapBounds.init(fromCenter: center, withSpan: span)
    }

}
