//
//  MapToolBar.swift
//  FruitWalk
//
//  Created by Claire S on 7/28/25.
//

import SwiftUI

/// A custom view modifier which adds Map ToolbarItems to a NavigationStack
/// These include a NavigationBarTitle and list, search and add buttons
struct MapViewToolBar: ViewModifier {
    @Environment(MapStore.self) private var mapStore
    @Binding var presentedSheet: MapSheetManager

    func body(content: Content) -> some View {
        content
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
                    Button {
                        presentedSheet.sheet = .search
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Use SimpleMessageView to display unimplemented feature message
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
    }
}

extension View {
    /// Applies the toolbar enhancements defined in MapViewToolBar to the NavigationStack
    func mapToolbar(
        presentedSheet: Binding<MapSheetManager>
    ) -> some View {
        self.modifier(MapViewToolBar(presentedSheet: presentedSheet))
    }
}


