//
//  MapFavoritesButton.swift
//  FruitWalk
//
//  Created by Claire S on 3/16/25.
//

import SwiftUI

struct MapFavoritesButton: View {
    @Environment(MapStore.self) private var mapStore
    @Binding var showFavoritesOnly: Bool
    @State var showingFavoritesAlert:Bool = false
    
    var body: some View {
        Button {
            if !showFavoritesOnly && !UserDefaults.standard.suppressFavoritesAlert {
                showingFavoritesAlert.toggle()
            }
            showFavoritesOnly.toggle()
        } label: {
            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                .tint(.red)
                .padding(12)
        }
        .background(.white, in: Circle())
        .disabled(mapStore.data.locations.isEmpty)
        .alert("Selecting the Heart will show Only locations marked as \"favorite\" on the Map", isPresented: $showingFavoritesAlert) {
            Button("OK") {

            }
            Button("Don't show again") {
                UserDefaults.standard.suppressFavoritesAlert = true
            }
        }
        message: {
            Text("To \"favorite\" a location, tap the tree marking the location and tap the heart\(Image(systemName: "heart")) in the location details.")
        }
    }
}
