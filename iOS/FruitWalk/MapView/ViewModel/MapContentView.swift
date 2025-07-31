//
//  MapContentView.swift
//  FruitWalk
//
//  Created by Claire S on 7/28/25.
//

import SwiftUI
import MapKit

let MAP_MAX_DISTANCE = 1_000_000.0

struct MapContentView: View {
    // MARK: - Environment Objects
    
    @Environment(MapStore.self) private var mapStore
    @Environment(LocationManager.self) private var locationManager
    
    // MARK: - View Dependencies
    
    var geo: GeometryProxy
    
    // MARK: - Bindings (from parent)
    
    @Binding var selectedTab: Int                   // Selected tab index (used to detect active tab)
    @Binding var showFavoritesOnly: Bool            // Whether to show only favorite fruits
    @Binding var filter: FruitFilter?                  // filter on types of fruit (if any) to apply to the map
    @Binding var lookAroundData: LookAroundData     // Controls Look Around viewer content
    @Binding var presentedSheet: MapSheetManager    // Manages which sheet is currently presented
    
    // MARK: - Internal State
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var mapSearch: SearchResultItem?    // Results from an address search for repositioning the map
    @State private var selectedId: Int?                // Currently selected fruit location on the map. Shows a popup with more details.
    @State private var lastSelectedId: Int?            // Remembers previous selection for UI continuity
    
    var body: some View {
        MapReader { mapProxy in
            Map(
                position: $position,
                bounds: MapCameraBounds(minimumDistance: 10.0, maximumDistance: MAP_MAX_DISTANCE),
                selection: $selectedId
            ) {
                let favorites = UserDefaults.standard.favorites
                
                // Add annotations for each location in the dataset
                ForEach(mapStore.data.locations.indices) { index in
                    // Logic to determine if if and how the location should be shown
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
            
                // Add clustered annotations
                ForEach(mapStore.data.clusters) { cluster in
                    Annotation("", coordinate: cluster.coordinate) {
                        cluster.annotationView(count: cluster.count , isSelected: false, hide: false)
                    }
                }
                
                // Add a marker for a search selection, if present
                if let mapSearch = mapSearch {
                    Marker(mapSearch.title, coordinate: mapSearch.coordinate)
                }
            }
            // default framework map controls (user location and compass)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            // Respond to camera (region) changes
            .onMapCameraChange(frequency: .onEnd) { context in
                handleMapRegionChange(context: context, geo: geo)
            }
            // Listen for notifications with coordinates to reposition the map
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.SelectMapLocation)) { notification in
                handleSelectMapNotification(notification: notification, geo: geo)
            }
            // Respond to tab changes (e.g., switching to and from the map)
            .onChange(of: selectedTab) { _, newValue in handleTabChange(newValue: newValue) }
            // React to camera position changes (e.g., user pans/zooms)
            .onChange(of: position) { handlePositionChange() }
            // Show details sheet when a fruit is selected
            .onChange(of: selectedId) { handleSelectedItemChange() }
            // If the search result changes, update the map position
            .onChange(of: mapSearch) { handleSearchItemChange(geo: geo) }
            // Tap to clear selection or dismiss UI elements
            .onTapGesture { handleTapGesture() }
            // Present appropriate sheet (detail, list, search)
            .mapSheet(presentedSheet: $presentedSheet, selectedId: $selectedId, lastSelectedId: $lastSelectedId, filter: $filter, lookAroundData: $lookAroundData, mapSearch: $mapSearch)
        }
    }
    
    // MARK: - Map Event Handlers
    
    /// Called when the visible map region changes
    func handleMapRegionChange(context: MapCameraUpdateContext, geo: GeometryProxy) {
        // Check if the user is viewing the map tab
        guard selectedTab == MainTabs.map else { return }
        
        // Create a region object representing the current visible map area
        let newRegion = MapRegion(
            mkRegion: context.region,
            viewSize: geo.size,
            heading: context.camera.heading
        )
        
        // Debug: print the current zoom level
        print("onMapCameraChange ZOOM: \(newRegion.zoom)")
        
        // Asynchronously fetch fruit data for this region
        Task {
            await mapStore.fetchFruit(for: newRegion)
        }
    }
    
    ///  handles the notification to insure the map tab is selected and reposition the map on the fruit mapItem
    func handleSelectMapNotification(notification: Notification, geo: GeometryProxy) {
        if let userInfo = notification.userInfo, let item = userInfo["mapItem"] as? MapItem {
            selectedId = nil
            if selectedTab != MainTabs.map {
                selectedTab = MainTabs.map
            }
            // hide popups
            presentedSheet.sheet = nil
            // center the fruit location on the map using zoom 20
            position = .region(MKCoordinateRegion( center: item.coordinate,
                                                   span: MKCoordinateSpan(zoom: 20, viewSize: geo.size, centerLatitude: item.coordinate.latitude)
            ))
            // assign to lastSelectedId to show the selection without the details sheet popping up
            lastSelectedId = item.identifier
        }
    }
    
    /// Called when the tab changes ensures locationManager continuous updates are turned on
    func handleTabChange(newValue: Int) {
        if newValue == MainTabs.map {
            // we want continuous updates when the user is viewing the map
            locationManager.startContinuousUpdates()
            if lastSelectedId == nil && selectedId == nil {
                position = .userLocation(followsHeading: true, fallback: .automatic)
            }
        }
    }
    
    /// Handles logic when camera position changes
    func handlePositionChange() {
        // if programatically setting the position (by user tapping user location button, setting a new region ...)
        if !position.positionedByUser, let search = mapSearch {
            // and the mapSearch coordinate is not within the map region, clear the mapSearch
            if position.region == nil || !position.region!.contains(coordinate: search.coordinate) {
                mapSearch = nil
           }
        }
    }
    
    /// Handles selection logic shows the detail sheet for the selected fruit location
    func handleSelectedItemChange() {
        if selectedId != nil {
            presentedSheet.sheet = .detail
            lookAroundData.clearData()
            lastSelectedId = nil
        }
    }
    
    /// Moves the map to a new region and dismisses popups
    func handleSearchItemChange(geo: GeometryProxy) {
        if let mapSearch = mapSearch {
            // update the map to the search coordinates, use zoom 17
            position = .region(MKCoordinateRegion(
                center: mapSearch.coordinate,
                span: MKCoordinateSpan(zoom: 17, viewSize: geo.size, centerLatitude: mapSearch.coordinate.latitude)
            ))
        }
        presentedSheet.sheet = nil
    }
    
    func handleTapGesture() {
        // assign to lastSelectedId to show the selection without the details sheet popping when
        lastSelectedId = selectedId
        selectedId = nil
        // dimiss lookaround or error message
        lookAroundData.clearData()
    }

}

