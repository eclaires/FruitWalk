//
//  FruitDetailsButtonBar.swift
//  FruitWalk
//
//  Created by Claire S on 3/25/25.
//

import SwiftUI
import MapKit

struct FruitDetailsButtonBar: View {
    @Binding var lookAroundData: LookAroundData
    @Binding var filter: FruitFilter?
    var location: FruitLocation
    
    var body: some View {
        HStack(alignment: .top) {
            Text(location.displayName)
                .multilineTextAlignment(.leading)
                .bold()
            Spacer()
            FilterButton(location: location, filter: $filter)
            Button {
                // if we have look around data clear it, otherwise fetch new look around data.
                if lookAroundData.coordinate != nil {
                    lookAroundData.clearData()
                } else {
                    Task {
                        await lookAroundData.getScene(from: location.coordinate)
                    }
                }
            } label: {
                Image(systemName: lookAroundData.coordinate != nil ? "binoculars.fill" : "binoculars")
            }
            FavoritesButton(location: location)
        }
        .padding(EdgeInsets(top: 16.0, leading: 16.0, bottom: 0, trailing: 16.0))
    }
}
