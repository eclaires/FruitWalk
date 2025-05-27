//
//  MKCoordinateRegion+.swift
//  FruitWalk
//
//  Created by Claire S on 2/24/25.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    
    func bounds() -> MapBounds {
        return MapBounds(fromRegion: self)
    }

    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let myBounds = bounds()
        return myBounds.contains(coordinate)
    }
}
 
