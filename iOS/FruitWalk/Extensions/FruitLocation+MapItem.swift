//
//  FruitLocation+MapItem.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation
import SwiftUI
import MapKit

extension FruitLocation: MapItem {
    var displayName: String {
        return typeNames?.joined(separator: ", ").capitalized ?? "un-named fruit"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func annotationView(count: Int, isSelected: Bool, hide: Bool) -> AnyView {
        @ViewBuilder var content: some View {
            ZStack(alignment: .bottom) {
                Ellipse()
                    .stroke(.blue, lineWidth: 2)
                    .background(.yellow)
                    .frame(width: 30, height: 12)
                    .opacity(isSelected ? 1.0 : 0.0)
                Image("multifruit_icon")
            }
            .opacity(hide ? 0.4 : 1.0)
        }
        return AnyView(content)
    }
    
}
