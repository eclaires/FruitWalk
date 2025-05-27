//
//  ShowOnMapButton.swift
//  FruitWalk
//
//  Created by Claire S on 3/26/25.
//

import SwiftUI

struct ShowOnMapButton: View {
    let location: FruitLocation
    
    var body: some View {
        Button {
            Task {
                NotificationCenter.default.post(name: NSNotification.SelectMapLocation,
                                                object: nil, userInfo: ["mapItem": location])
            }
        } label: {
            Image(systemName: "map")
        }
    }
}
