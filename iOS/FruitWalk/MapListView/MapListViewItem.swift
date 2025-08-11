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
    // state variable used to force a refresh when the view disappears and reappears, needed when used in a UITableView and recycled. Fixes issue where the favorites button was not updated
    @State var needsRefresh: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                TitleLink(location: location)
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
        .onAppear() {
            needsRefresh.toggle()
        }
        .onDisappear() {
            needsRefresh.toggle()
        }
    }
}
