//
//  TitleLink.swift
//  FruitWalk
//
//  Created by Claire S on 6/4/25.
//

import SwiftUI

struct TitleLink: View {
    let location: FruitLocation
    
    var body: some View {
        if let names = location.typeNames {
            VStack(alignment: .leading) {
                ForEach(names, id: \.self) { name in
                    // The type in the array iterated must be identifiable. The strings are assumed
                    // to be unique, \.self indicates each string's identity is the string itself.
                    if let url = URL.wikipediaURL(term: name) {
                        Text(.init("[\(name)](\(url))"))
                            .underline()
                    }
                }
            }
        } else {
            Text(location.displayName)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.primary)
                .bold()
        }
    }
}

