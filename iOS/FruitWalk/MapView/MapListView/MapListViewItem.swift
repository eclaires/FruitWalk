//
//  MapListViewItem.swift
//  FruitWalk
//
//  Created by Claire S on 4/11/25.
//

import SwiftUI
import MapKit

/// SwiftUI view used for a single row item in the MapListView's UITableView
struct MapListViewItem: View {
    let location: FruitLocation
    @Binding var filter: FruitFilter?
    let startCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            HStack {
                Text(location.displayName)
                    .bold()
                    .foregroundStyle(Color.primary)
                Spacer()
                FilterButton(location: location, filter: $filter)
                FavoritesButton(location: location)
                ShowOnMapButton(location: location)
            }
            .opacity((filter != nil && !filter!.contains(location)) ? 0.5 : 1.0)
            Spacer()
                .frame(height: 8)
            DistanceView(fruitLocation: location, includeDirections: true, startCoordinate: startCoordinate)
        }
    }
}
