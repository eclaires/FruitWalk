//
//  FruitWalkApp.swift
//  FruitWalk
//
//  Created by Claire S on 2/17/25.
//

import SwiftUI
import SwiftData
//import Firebase

struct MainTabs {
    static let map = 0
    static let favorite = 1
    static let info = 2

    static var defaultTab: Int {
        return map
    }
}

@main
struct FruitWalkApp: App {
    @State private var locationManager = LocationManager()
    @State private var mapStore = MapStore()
    
    @State private var selectedTab: Int = MainTabs.map
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                MapView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Map", systemImage: "book")
                            .foregroundStyle(.green)
                    }
                    .tag(MainTabs.map)
                FavoritesView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                            .foregroundStyle(.red)
                    }
                    .tag( MainTabs.favorite)
                UserView()
                    .tabItem {
                        Label("Info", systemImage: "info.circle.fill")
                    }
                    .tag(MainTabs.info)
            }
        }
        .environment(locationManager)
        .environment(mapStore)
    }
}
