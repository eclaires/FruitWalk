//
//  ProgressBar.swift
//  FruitWalk
//
//  Created by Claire S on 7/11/25.
//

import SwiftUI

/// SwiftUI view that displays an indeterminate progress bar. Animates when shown.
struct AnimatedProgressBar: View {
    @State private var animateGradient = false
    @State private var startColor = Color(red: 0x53/255.0, green: 0xe0/255.0, blue: 0x04/255.0)
    @State private var endColor = Color(red: 0x20/255.0, green: 0x54/255.0, blue: 0x01/255.0)
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Loading...")
                .font(.callout)
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            animateGradient ? startColor : endColor,
                            animateGradient ? endColor : startColor
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 10)
                .padding(6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
        .onDisappear {
            animateGradient.toggle()
        }
    }
}

/* Circle version

/// SwiftUI view that displays an indeterminate progress bar. Animates when shown.
struct AnimatedProgressSpinner: View {
    @State private var rotationDegrees: Double = 0
    private var lighest = Color(red: 0xba/255.0, green: 0xf2/255.0, blue: 0x9a/255.0)
    private var lighter = Color(red: 0x7c/255.0, green: 0xfb/255.0, blue: 0x35/255.0)
    private var darker = Color(red: 0x37/255.0, green: 0x95/255.0, blue: 0x03/255.0)
    private var darkest = Color(red: 0x21/255.0, green: 0x59/255.0, blue: 0x01/255.0)

    var body: some View {
        Circle()
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [lighest, lighter, darker, darkest]),
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360)
                ),
                style: StrokeStyle(lineWidth: 20, lineCap: .round)
            )
            .opacity(0.7)
            .frame(width: 20, height: 20)
            .rotationEffect(.degrees(rotationDegrees))
            .padding(20)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotationDegrees = 360
                }
            }
    }
}
 */


