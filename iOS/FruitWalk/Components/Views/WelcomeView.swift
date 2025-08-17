//
//  WelcomeView.swift
//  FruitWalk
//
//  Created by Claire S on 8/14/25.
//

import SwiftUI

private let checkboxImage = Image(systemName: "checkmark.rectangle.portrait.fill")
private let fallingFruitLink = "**[Falling Fruit](https://fallingfruit.org/about)**"

struct WelcomeView: View {
    @Binding var welcomeAccepted: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Welcome to")
                Image("sneaker_icon")
                Text("Fruit Walk")
            }
            .bold()
            .padding(EdgeInsets(top: 16.0, leading: 0, bottom: 0, trailing: 0))
            Text("Fruit walk provides a map of neighborhood fruit. Fruit may be on public land or an overhang onto public land.\n\nWhen finding fruit, be Respectful.\(checkboxImage) Only pick fruit for immediate use.\(checkboxImage) Remember that someone else is watering, feeding and cultivating the fruit.\(checkboxImage) Take a piece only when there is an abundance.\(checkboxImage)\n\nFruit walk uses the data gathered by \(fallingFruitLink), a 501(c)(3) nonprofit.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("dark_green"))
                .padding()
            Button ("I Understand") {
                welcomeAccepted = true
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        }
        .background(Color("green_background").opacity(0.9))
        .padding(20)
    }
}

