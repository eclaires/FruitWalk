//
//  DirectionsButton.swift
//  FruitWalk
//
//  Created by Claire S on 3/26/25.
//

import SwiftUI
import MapKit

struct DirectionsButton: View {
    let location: FruitLocation
    @Environment(LocationManager.self) var locationManager
    
    var body: some View {
        Button {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            mapItem.name = location.displayName
            var meters = 0.0
            if let userLocation = locationManager.userLocation {
                meters = location.coordinate.approximateDistance(from: userLocation.coordinate)
            }
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: WalkDistance.contains(meters) ? MKLaunchOptionsDirectionsModeWalking : MKLaunchOptionsDirectionsModeDefault])
        } label: {
            HStack(alignment: .top) {
                Image(systemName: "arrow.trianglehead.turn.up.right.circle")
                Text("Directions")
                    .font(.caption)
            }
        }
    }
}
