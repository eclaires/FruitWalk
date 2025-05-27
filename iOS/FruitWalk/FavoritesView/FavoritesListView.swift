//
//  FavoritesListView.swift
//  FruitWalk
//
//  Created by Claire S on 3/21/25.
//

import SwiftUI
import UIKit
import MapKit

struct FavoritesListView: UIViewRepresentable {
    @Binding var sortOrder: FavoritesSortOrder
    @Binding var loadState: loadingState
    @Environment(LocationManager.self) var locationManager
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = context.coordinator
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        // if the sort changed set loading true,
        // Or a distance sort and location changed, force loading
        // "loading" is also set false by the view owner to force a reload
        if sortOrder != context.coordinator.currentSortOrder {
            print("+++ FavoritesListView sortOrder loadState = .loading +++")
            loadState = .loading
        }
        // Don't reload after loaded, elimmintaes unnecceasary updates
        if loadState == .loading {
            Task {
                if loadState != .cancelled {
                    print("+++ FavoritesListView called updateList +++")
                    loadState = await context.coordinator.updateList(using: sortOrder)
                    uiView.reloadData()
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(locationManager: locationManager)
    }
    
    final class Coordinator: NSObject, UITableViewDataSource {
        let locationManager: LocationManager
        private var favorites = [FruitLocation]()
        private(set) var currentSortOrder: FavoritesSortOrder = .defaultSort
        private(set) var sortedUserLocation: CLLocation?
        
        init(locationManager: LocationManager) {
            self.locationManager = locationManager
        }
        
        func updateList(using sortOrder: FavoritesSortOrder) async -> loadingState {
            favorites = [FruitLocation]()
            
            currentSortOrder = sortOrder
            let data = UserDefaults.standard.favorites
            print("!!! locationManager.userLocation is NIL \(locationManager.userLocation == nil ? "true" : "false")")
            
            if sortOrder.isDistanceSort {
                // if we have a user loaction populate the list, otherwise wait for the location
                if let userLocation = locationManager.userLocation {
                    sortedUserLocation = locationManager.userLocation
                    favorites = Array(data.values)
                        .sorted(by: {lhs, rhs in
                            if sortOrder == .distanceNearFar {
                                lhs.coordinate.approximateDistance(from: userLocation.coordinate) < rhs.coordinate.approximateDistance(from: userLocation.coordinate)
                            } else {
                                lhs.coordinate.approximateDistance(from: userLocation.coordinate) > rhs.coordinate.approximateDistance(from: userLocation.coordinate)
                            }
                        })
                    return .loaded
                } else {
                    favorites = [FruitLocation]()
                    return .loading
                }
            } else {
                favorites = Array(data.values)
                    .sorted(by: {lhs, rhs in
                        if sortOrder == .typeAZ {
                            lhs.displayName < rhs.displayName
                        } else {
                            lhs.displayName > rhs.displayName
                        }
                    })
                return .loaded
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favorites.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let location = favorites[indexPath.row]
            cell.contentConfiguration = UIHostingConfiguration {
                HStack {
                    FruitDetailsView(location: location, titleView: FavoritesItemButtonBar(location: location), startCoordinate: nil)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}

