//
//  FavoritesView.swift
//  FruitWalk
//
//  Created by Claire S on 2/21/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) var scenePhase
    @Binding var selectedTab: Int
    @State var sortOrder = FavoritesSortOrder.defaultSort
    @State var loadState: LoadingState = .cancelled
    @State var wasBackgrounded = false
    
    var body: some View {
        NavigationStack {
            if UserDefaults.standard.favorites.isEmpty {
                VStack {
                    Label {
                        Text("You haven't Favorited any fruit locations on the Map yet!")
                    } icon: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                        .frame(height: 20)
                    Label {
                        Text("Select a fruit location on the Map to add it to Favorites.")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                }
                .padding(30)
            } else {
                ZStack() {
                    FavoritesListView(sortOrder: $sortOrder, loadState: $loadState)
                        .environment(locationManager)
                    if loadState == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .background(.white, in: Circle())
                    }
                }
                .navigationTitle("Fruit Walk")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationBarTitle()
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker(selection: $sortOrder, label: Text("Sort")) {
                                ForEach(FavoritesSortOrder.allCases) {
                                    Text($0.title)
                                        .tag($0)
                                }
                            }
                        }
                        label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // Button Action
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
        } // NavigationStack
        .onChange(of: selectedTab) { oldValue, newValue in
            if oldValue != MainTabs.favorite && newValue == MainTabs.favorite {
                print("+++ onChange selectedTab loadState = .loading" )
                // trigger a reload of the list view
                loadState = .loading
                if locationManager.isContinuouslyUpdating {
                    locationManager.stopContinuousUpdates()
                } else {
                    locationManager.requestLocation(resetCurrent: true)
                }
            } else if newValue != MainTabs.favorite {
                loadState = .cancelled
            }
        }
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            guard sortOrder.isDistanceSort else { return }
            
            if selectedTab == MainTabs.favorite {
                if oldValue == nil && newValue != nil {
                    print("+++ onChange userLocation setting state loading...")
                    loadState = .cancelled // if it was loading rest to force relaod
                    loadState = .loading
                }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                if wasBackgrounded {
                    wasBackgrounded = false
                    if selectedTab == MainTabs.favorite {
                        print("+++ onChange scenePhase .active setting state loading...")
                        loadState = .loading
                    }
                }
            } else if newPhase == .inactive {
                if wasBackgrounded {
                    wasBackgrounded = false
                    if selectedTab == MainTabs.favorite {
                        print("+++ onChange scenePhase .inactive setting state loading...")
                        loadState = .loading
                    }
                }
            } else if newPhase == .background {
                wasBackgrounded = true
            }
        }
    }
}
