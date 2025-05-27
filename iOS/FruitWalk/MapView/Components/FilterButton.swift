//
//  FilterButton.swift
//  FruitWalk
//
//  Created by Claire S on 4/30/25.
//

import SwiftUI

struct FilterButton: View {
    let location: FruitLocation
    @Binding var filter: FruitFilter?
    
    var body: some View {
        Button {
            if let filtered = filter, filtered.contains(location) {
                filter = nil
            } else {
                filter = FruitFilter([location])
            }
        } label: {
            Image(systemName: filter != nil ?
                                    (filter!.contains(location) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                    : "line.3.horizontal.decrease.circle")
        }
    }
}
