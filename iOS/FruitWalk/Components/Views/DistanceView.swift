//
//  DistanceView.swift
//  FruitWalk
//
//  Created by Claire S on 4/10/25.
//

import SwiftUI
import MapKit

struct DistanceView: View {
    let fruitLocation: FruitLocation
    let includeDirections: Bool
    let startCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            HStack {
                if startCoordinate != nil {
                    Image(systemName: "location.circle.fill")
                        .foregroundStyle(.blue)
                }
                DistanceLabel(start: nil, end: fruitLocation.coordinate)
                Spacer()
                if includeDirections {
                    DirectionsButton(location: fruitLocation)
                }
            }
            if let start = startCoordinate {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.red)
                    DistanceLabel(start: start, end: fruitLocation.coordinate)
                    Spacer()
                }
            }
        }
    }
}

