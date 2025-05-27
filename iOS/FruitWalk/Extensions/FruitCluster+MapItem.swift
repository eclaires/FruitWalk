//
//  FruitCluster+MapItem.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation
import SwiftUI
import MapKit

extension FruitCluster: MapItem {
    var identifier: Int {
        return id.hashValue
    }
    
    var displayName: String {
        ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func annotationView(count: Int, isSelected: Bool, hide: Bool) -> AnyView {
        @ViewBuilder var content: some View {
            ZStack {
                Text(count.description)
                    .bold()
                    .font(.caption)
                    .foregroundStyle(Color("dark_green"))
                    .padding(6)
            }
            .background(.yellow)
            .clipShape(Capsule())
        }
        return AnyView(content)
    }
}

