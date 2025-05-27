//
//  NavigationBarTitle.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import SwiftUI

struct NavigationBarTitle: View {
    var body: some View {
        HStack {
            Image("sneaker_icon")
            Text("Fruit Walk")
                .bold()
        }
    }
}

#Preview {
    NavigationBarTitle()
}
