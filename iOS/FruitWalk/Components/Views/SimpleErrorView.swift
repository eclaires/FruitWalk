//
//  SimpleErrorView.swift
//  FruitWalk
//
//  Created by Claire S on 3/15/25.
//
// Work in progress!! simple view to show a message and dismissed on tap

import SwiftUI

struct SimpleErrorView: View {
    let message: String
    
    var body: some View {
        VStack() {
            Text(message)
                .padding(20)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background(.white, in: Rectangle())
        .border(.black)
    }
}

