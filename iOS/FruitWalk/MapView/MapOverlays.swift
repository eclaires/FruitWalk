//
//  MapOverlays.swift
//  FruitWalk
//
//  Created by Claire S on 7/28/25.
//

import SwiftUI

/// A custom view modifier which displays overlays on top of a Map
/// These include favorites, filters and loading indicators and Look Around Viewer
///
struct MapViewOverlayModifier: ViewModifier {
    /// The shared map data store
    @Environment(MapStore.self) private var mapStore
    /// Toggle to know if only favorite locations are shown
    @Binding var showFavoritesOnly: Bool
    /// Optional filter applied to the map
    @Binding var filter: FruitFilter?
    /// Look Around viewer data (shows viewer if `scene` is available)
    @Binding var lookAroundData: LookAroundData

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                // Top Center - show the favorites and filter indicators
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
                .padding(.top, 6)
            }
            .overlay(alignment: .top) {
                // Top - Show the Look Around viewer
                if lookAroundData.scene != nil {
                    LookAroundViewer(lookAroundData: $lookAroundData)
                }
            }
            .overlay(alignment: .bottom) {
                // Bottom - show the loading progress indicator when fetching data
                if mapStore.data.status == .loading {
                    AnimatedProgressBar()
                }
            }
    }
}

extension View {
    /// Applies the custom map overlays, MapViewOverlayModifier, to the view
    func mapOverlays(
        showFavoritesOnly: Binding<Bool>,
        filter: Binding<FruitFilter?>,
        lookAroundData: Binding<LookAroundData>
    ) -> some View {
        self.modifier(MapViewOverlayModifier(
            showFavoritesOnly: showFavoritesOnly,
            filter: filter,
            lookAroundData: lookAroundData
        ))
    }
}
