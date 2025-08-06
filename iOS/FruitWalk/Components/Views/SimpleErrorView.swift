//
//  SimpleMessageView.swift
//  FruitWalk
//
//  Created by Claire S on 3/15/25.

import SwiftUI

struct SimpleMessageView: View {
    @Binding var showErrorMessage: Bool
    let title: String
    let message: String
    
    var body: some View {
        VStack() {
            HStack() {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Button(action: {
                    showErrorMessage = false
                }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.primary)
                        .font(.title)
                }
            }
            .padding([.top, .leading, .trailing], 12)
            Text(message)
                .padding([.bottom, .trailing], 12)
                .multilineTextAlignment(.center)
        }
        .background(.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

