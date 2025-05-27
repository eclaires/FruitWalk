//
//  FavoritesItemButtonBar.swift
//  FruitWalk
//
//  Created by Claire S on 3/25/25.
//

import SwiftUI

struct FavoritesItemButtonBar: View {
    var location: FruitLocation
    
    var body: some View {
        HStack(alignment: .center) {
            Text(location.displayName)
                .lineLimit(3)
                .bold()
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            Spacer()
            FavoritesButton(location: location)
            ShowOnMapButton(location: location)
        }
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("green_foreground"), lineWidth: 2)
        )
    }
}
