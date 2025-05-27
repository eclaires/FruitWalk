//
//  MKCoordinateSpan+Calc.swift
//  FruitWalk
//
//  Created by Claire S on 5/23/25.
//

import Foundation
import MapKit

extension MKCoordinateSpan {
    
    /// Init function to construct a MKCoordinateSpan using a Mercator zoom level, view size, and the center lattitude.
    /// The calculation is approximate enough for this application
    /// 256 is the base tile size in Web Mercator, at zoom level 0, the entire world is mapped into one single tile
    /// - Parameters:
    ///   - zoom: Mercator zoom  desired
    ///   - viewSize: the size of the view displaying the map
    ///   - centerLatitude: the map center's latitude (degrees)
    init(zoom: Int, viewSize: CGSize, centerLatitude: CLLocationDegrees) {
        self.init()
        
        // map scale - each zoom level doubles the map resolution
        let scale = pow(2.0, Double(zoom))
        // calculate the degrees of longitude covered by one pixel
        let longDegPerPixel = 360.0 / (256.0 * scale)
        // multiply by view width to get the longitute span
        let longitudeSpan = Double(viewSize.width) * longDegPerPixel
        // convert lattitude to radians
        let centerLatRad = centerLatitude * .pi / 180.0
        // calculate latitude degrees per pixel, adjusted by cosine of latitude
        // this corrects for Mercator projection distortion as you move away from equator
        let latDegPerPixel = longDegPerPixel / cos(centerLatRad)
        // multiply by view height to get the longitute span
        let latitudeSpan = Double(viewSize.height) * latDegPerPixel

        self.longitudeDelta = CLLocationDegrees(longitudeSpan)
        self.latitudeDelta = CLLocationDegrees(latitudeSpan)
    }
    
}
