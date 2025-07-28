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
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
                    .onDisappear {
                        animateGradient.toggle()
                    }
                    .frame(width: 150, height: 10)
                    .padding(6)
        
    }
}


