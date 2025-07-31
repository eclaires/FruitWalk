//
//  MapView.swift
//  FruitWalk
//
//  Created by Claire S on 2/17/25.
//

import MapKit
import SwiftUI

/// View to display the contents of the FruitWalk map, overlays and show a navigation title and buttons
struct MapView: View {
    
    // MARK: - Environment Objects
    
    @Environment(MapStore.self) private var mapStore
    @Environment(LocationManager.self) private var locationManager
    
    // MARK: - Bindings (from parent)
    
    @Binding var selectedTab: Int                   // Selected tab index (used to detect active tab)

    // MARK: - Internal State
    
    @State private var lookAroundData = LookAroundData()    // when lookaround data is set, displays a look around viewer
    @State private var filter: FruitFilter?                 // a filter applied to the fruit data
    @State private var showFavoritesOnly = false            // whether to show only fruit locations which are favorited
    @State private var errorMessage: String?
    @State private var presentedSheet: MapSheetManager = .init()
    @State private var showSimpleMessage: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                ZStack {
                    MapContentView(geo: geometryProxy, selectedTab: $selectedTab, showFavoritesOnly: $showFavoritesOnly, filter: $filter, lookAroundData:$lookAroundData, presentedSheet: $presentedSheet)
                        .environment(mapStore)
                        .environment(locationManager)
                        .mapOverlays(showFavoritesOnly: $showFavoritesOnly, filter: $filter, lookAroundData: $lookAroundData)
                        .environment(mapStore)
                    
                }
                if let errorMessage = lookAroundData.errorMessage {
                    HStack {
                        SimpleErrorView(message: errorMessage)
                    }
                    .padding(20)
                    .allowsHitTesting(false)
                }
            }
            .navigationTitle("Fruit Walk")
            .navigationBarTitleDisplayMode(.inline)
            .mapToolbar(presentedSheet: $presentedSheet)
        }
    }
}

