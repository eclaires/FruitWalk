//
//  LookAroundViewer.swift
//  FruitWalk
//
//  Created by Claire S on 3/14/25.
//

import SwiftUI
import MapKit

struct LookAroundViewer: View {
    @Binding var lookAroundData: LookAroundData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundData.scene, allowsNavigation: true)
            .overlay(alignment: .topTrailing, content: {
                HStack(alignment: .top) {
                    Button {
                        dismiss()
                        lookAroundData.clearData()
                    } label: {
                        Image(systemName: "x.circle")
                            .tint(.black)
                            .padding(3)
                    }
                }
                .background(.white, in: Circle())
                .padding(8)
                .opacity(0.8)
            })
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(height: 300)
            .padding()
    }
}
