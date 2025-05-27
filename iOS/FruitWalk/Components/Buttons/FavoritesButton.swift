//
//  FavoritesButton.swift
//  FruitWalk
//
//  Created by Claire S on 3/26/25.
//

import SwiftUI

struct FavoritesButton: View {
    var location: FruitLocation
    @State var favorites: [Int: FruitLocation] = UserDefaults.standard.favorites
    
    var body: some View {
        Button {
            if favorites[location.identifier] != nil {
                favorites[location.identifier] = nil
                UserDefaults.standard.favorites = favorites
            } else {
                favorites[location.identifier] = location
                UserDefaults.standard.favorites = favorites
            }
        } label: {
            Image(systemName: favorites[location.identifier] != nil ? "heart.fill" : "heart")
                .tint(.red)
        }
    }
}

