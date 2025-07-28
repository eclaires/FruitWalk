//
//  MapView.swift
//  FruitWalk
//
//  Created by Claire S on 2/17/25.
//

import MapKit
import SwiftUI

let MAP_MAX_DISTANCE = 1_000_000.0

struct MapView: View {
    @Binding var selectedTab: Int
    @Environment(MapStore.self) private var mapStore
    @Environment(LocationManager.self) private var locationManager
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var lookAroundData = LookAroundData()
    @State private var searchSelection: SearchResultItem?
    @State private var filter: FruitFilter?
    @State private var showFavoritesOnly = false
    @State private var selectedId: Int?
    @State private var lastSelectedId: Int?
    @State private var errorMessage: String?
    @State private var presentedSheet: MapSheet = .init()

    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                ZStack {
                    MapReader { mapProxy in
                        Map(position: $position, bounds: MapCameraBounds(minimumDistance: 10.0, maximumDistance: MAP_MAX_DISTANCE), selection: $selectedId) {
                            
                            let favorites = UserDefaults.standard.favorites
                            
                            ForEach(mapStore.data.locations.indices) { index in
                                let location = mapStore.data.locations[index]
                                let filterApplied = filter != nil || showFavoritesOnly
                                let inFilter = (filter != nil && filter!.contains(location)) || (showFavoritesOnly && favorites[location.identifier] != nil)
                                let displaySelected = location.identifier == selectedId || location.identifier == lastSelectedId
                                let hide = (filterApplied && !inFilter) && !displaySelected
                                
                                Annotation(location.displayName, coordinate: location.coordinate) {
                                    location.annotationView(count: mapStore.data.locations.count, isSelected: displaySelected, hide: hide)
                                }
                                .annotationTitles(hide ? .hidden : (inFilter ? .visible : .automatic))
                                .tag(location.identifier)
                            }
                        
                            ForEach(mapStore.data.clusters) { cluster in
                                Annotation("", coordinate: cluster.coordinate) {
                                    cluster.annotationView(count: cluster.count , isSelected: false, hide: false)
                                }
                            }
                            
                            if let searchSelection = searchSelection {
                                Marker(searchSelection.title, coordinate: searchSelection.coordinate)
                            }
                        } // Map
                        .mapControls {
                            MapUserLocationButton()
                            MapCompass()
                        }
                        .onMapCameraChange(frequency: .onEnd /*.continuous*/) { context in
                            guard selectedTab == MainTabs.map else {
                                return
                            }
                            let newRegion = MapRegion(mkRegion: context.region, viewSize: geometryProxy.size, heading: context.camera.heading)
                            print("onMapCameraChange ZOOM: \(newRegion.zoom)")
                            Task {
                                do {
                                    await mapStore.fetchFruit(for: newRegion)
                                }
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.SelectMapLocation)) { obj in
                            if let userInfo = obj.userInfo, let item = userInfo["mapItem"] as? MapItem {
                                selectedId = nil
                                if selectedTab != MainTabs.map {
                                    selectedTab = MainTabs.map
                                }
                                // hide popups
                                presentedSheet.sheet = nil
                                // center the fruit location on the map using zoom 20
                                position = .region(MKCoordinateRegion( center: item.coordinate,
                                                                       span: MKCoordinateSpan(zoom: 20, viewSize: geometryProxy.size, centerLatitude: item.coordinate.latitude)
                                ))
                                // assign to lastSelectedId to show the selection without the details sheet popping up
                                lastSelectedId = item.identifier
                            }
                        }
                        .onChange(of: selectedTab) { oldValue, newValue in
                            if newValue == MainTabs.map {
                                // we want continuous updates when the user is viewing the map
                                locationManager.startContinuousUpdates()
                                if lastSelectedId == nil && selectedId == nil {
                                    position = .userLocation(followsHeading: true, fallback: .automatic)
                                }
                            }
                        }
                        .onChange(of: position) {
                            // if programatically setting the position (by user tapping user location button, setting a new region ...)
                            if !position.positionedByUser, let search = searchSelection {
                                // and the searchSelection coordinate is not within the map region, clear the searchSelection
                                if position.region == nil || !position.region!.contains(coordinate: search.coordinate) {
                                    searchSelection = nil
                               }
                            }
                        }
                        .onChange(of: selectedId) {
                            if selectedId != nil {
                                presentedSheet.sheet = .detail
                                lookAroundData.clearData()
                                lastSelectedId = nil
                            }
                        }
                        .onChange(of: searchSelection) {
                            // hide popups
                            if let searchSelection = searchSelection {
                                // update the map to the search coordinates, use zoom 17
                                position = .region(MKCoordinateRegion(
                                    center: searchSelection.coordinate,
                                    span: MKCoordinateSpan(zoom: 17, viewSize: geometryProxy.size, centerLatitude: searchSelection.coordinate.latitude)
                                ))
                            }
                            presentedSheet.sheet = nil
                        }
                        .sheet(item: $presentedSheet.sheet,
                               onDismiss: {
                            switch presentedSheet.lastSHownSheet {
                            case .detail:
                                // set selectedId to nil so the item can be selected again to show the sheet
                                // set lastSelectedId to the selectedId so the item still appears selected
                                lastSelectedId = selectedId
                                selectedId = nil
                            default:
                                break
                            }
                        },
                               content: { sheet in
                            switch sheet {
                            case .detail:
                                if selectedId != nil, let data = mapStore.data.locations.first(where: { $0.identifier == selectedId }) {
                                    let buttonBar = FruitDetailsButtonBar(lookAroundData: $lookAroundData, filter: $filter, location: data)
                                    FruitDetailsView(location: data, titleView: buttonBar, startCoordinate: searchSelection?.coordinate)
                                        .presentationDetents([.medium, .large])
                                }
                            case .list:
                                MapListView(filter: $filter, startCoordinate: searchSelection?.coordinate)
                                    .presentationDetents([.medium, .large])
                            case .search:
                                SearchView(selection: $searchSelection)
                                    .presentationDetents([.large])
                            }
                        })
  
                    } // MapReader
                    .onTapGesture { position in
                        // assign to lastSelectedId to show the selection without the details sheet popping when
                        lastSelectedId = selectedId
                        selectedId = nil
                        // dimiss lookaround or error message
                        lookAroundData.clearData()
                    }
                    .overlay(alignment: .top) {
                        HStack(alignment: .center) {
                            MapFavoritesButton(showFavoritesOnly: $showFavoritesOnly)
                            if filter != nil && mapStore.data.clusters.isEmpty {
                                Button {
                                    filter = nil
                                } label: {
                                    Label(filter!.displayName(), systemImage: "x.circle.fill")
                                        .lineLimit(1)
                                        .padding(12)
                                        .background(.white)
                                        .foregroundStyle(Color.primary)
                                        .clipShape(Capsule(style: .continuous))
                                }
                            }
                            Spacer(minLength: 40.0)
                        }
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                    }
                    .overlay(alignment: .top) {
                        if lookAroundData.scene != nil {
                            LookAroundViewer(lookAroundData: $lookAroundData)
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if mapStore.data.status == .loading {
                            AnimatedProgressBar()
                        }
                    }
                    
                } // ZStack
                if let errorMessage = lookAroundData.errorMessage {
                    HStack {
                        SimpleErrorView(message: errorMessage)
                    }
                    .padding(20)
                    .allowsHitTesting(false)
                }
            } // GeometryReader
            .navigationTitle("Fruit Walk")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    NavigationBarTitle()
                }
                ToolbarItem(placement: .topBarLeading) {
                        Button {
                            presentedSheet.sheet = .list
                        } label: {
                            Image(systemName: "list.dash")
                        }
                        .background(.white, in: Circle())
                        .disabled(mapStore.data.locations.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        presentedSheet.sheet = .search
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // TODO: Use SimpleErrorView to display unimplemented message
                        // Button Action
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        } // NavigationStack
    } // View

}

