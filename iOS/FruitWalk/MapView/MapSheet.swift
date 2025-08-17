//
//  MapSheet.swift
//  FruitWalk
//
//  Created by Claire S on 7/31/25.
//

import Foundation
import SwiftUI

struct MapSheet: ViewModifier {
    /// The shared map data store
    @Environment(MapStore.self) private var mapStore
    @Binding var presentedSheet: MapSheetManager
    @Binding var selectedId: Int?
    @Binding var lastSelectedId: Int?
    @Binding var filter: FruitFilter?
    @Binding var lookAroundData: LookAroundData
    @Binding var mapSearch: SearchResultItem?

    func body(content: Content) -> some View {
        content.sheet(item: $presentedSheet.sheet,
               onDismiss: {
            switch presentedSheet.lastSHownSheet {
            case .detail:
                // Reset selection so the detail sheet can be reopened
                lastSelectedId = selectedId
                selectedId = nil
            default:
                break
            }
        },
               content: { sheet in
            switch sheet {
            case .detail:
                // Show fruit details if an item is selected
                if selectedId != nil, let data = mapStore.data.locations.first(where: { $0.identifier == selectedId }) {
                    let buttonBar = FruitDetailsButtonBar(lookAroundData: $lookAroundData, filter: $filter, location: data)
                    FruitDetailsView(location: data, titleView: buttonBar, startCoordinate: mapSearch?.coordinate)
                        .presentationDetents([.medium, .large])
                }
            case .list:
                // show a sheet with a list of fruit locations on the map
                MapListView(filter: $filter, startCoordinate: mapSearch?.coordinate)
                    .presentationDetents([.medium, .large])
            case .search:
                // show the sheet for an address search/lookup
                SearchView(selection: $mapSearch)
                    .presentationDetents([.large])
            }
        })
    }
}

extension View {
    func mapSheet(
        presentedSheet: Binding<MapSheetManager>,
        selectedId: Binding<Int?>,
        lastSelectedId: Binding<Int?>,
        filter: Binding<FruitFilter?>,
        lookAroundData: Binding<LookAroundData>,
        mapSearch: Binding<SearchResultItem?>
    ) -> some View {
        modifier(MapSheet(
            presentedSheet: presentedSheet,
            selectedId: selectedId,
            lastSelectedId: lastSelectedId,
            filter: filter,
            lookAroundData: lookAroundData,
            mapSearch: mapSearch
        ))
    }
}

