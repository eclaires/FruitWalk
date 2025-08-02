//
//  MapOverlays.swift
//  FruitWalk
//
//  Created by Claire S on 7/28/25.
//

import SwiftUI


extension View {
    /// Applies the custom map overlays, MapViewOverlayModifier, to the view
    func mapOverlays(
        showFavoritesOnly: Binding<Bool>,
        filter: Binding<FruitFilter?>,
        lookAroundData: Binding<LookAroundData>,
        showErrorMessage: Binding<Bool>
    ) -> some View {
        self.modifier(MapViewOverlayModifier(
            showFavoritesOnly: showFavoritesOnly,
            filter: filter,
            lookAroundData: lookAroundData,
            showErrorMessage: showErrorMessage
        ))
    }
}

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
    /// show an error message on top of all views
    @Binding var showErrorMessage: Bool
    
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
                // Bottom - Show the loading progress indicator when fetching data
                if mapStore.data.status == .loading {
                    AnimatedProgressBar()
                }
            }
            .overlay(alignment: .top) {
                // Top - Show an error message on the top of the map over all other views
                if showErrorMessage, let error = lastError() {
                    let message = errorTitleAndDescription(error)
                    HStack {
                        SimpleMessageView(showErrorMessage: $showErrorMessage, title: message.title, message: message.description)
                    }
                    .padding(20)
                }
            }
    }
    
    /// Function to get the error message title and description.
    /// Provides a custom map specific title and description for the .noData case
    func errorTitleAndDescription(_ apiError: APIError) -> (title: String, description: String) {
        switch apiError {
        case .noData:
            return ("Fruit Not Found", "Fruit was not found at this location. Try moving the map.")
        default:
            return apiError.localizedErrorTitleAndDescription
        }
    }
    
    /// Returns the last error encountered, if any
    func lastError() -> APIError? {
        if let apiError = lookAroundData.error {
            return apiError
        } else {
            switch mapStore.data.status {
            case .failed(let apiError):
                return apiError
            default:
                return nil
            }
        }
    }
}
