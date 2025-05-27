//
//  SearchView.swift
//  FruitWalk
//
//  Created by Claire S on 4/6/25.
//

import SwiftUI
import MapKit

let defaultSearchString = "Look up address"

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(MapStore.self) private var mapStore
    @Binding var selection: SearchResultItem?
    @State private var lookup = MapSearch(completer: .init())
    @State private var query: String = ""
    @AppStorage(UserDefaults.Keys.lastMapSearch) private var storedQuery: String?
    
    var body: some View {
        VStack {
            HStack {
                TextField("", text: $query, prompt: Text(storedQuery != nil ? "" : defaultSearchString))
                    .autocorrectionDisabled()
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                Button {
                    storedQuery = nil
                    dismiss()
                } label: {
                    Image(systemName: "x.circle")
                        .tint(.black)
                        .padding(3)
                }
            }
            Spacer()
            // Add list of fruit Locations
            
            List(lookup.results, id: \.self, selection: $selection) {result in
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.title)
                        .font(.headline)
                        .fontDesign(.rounded)
                    Text(result.subTitle)
                }
            }
            .onChange(of: selection) {
                // If a fruit location select that location, otherwise go to an address
                storedQuery = query
            }
            .scrollContentBackground(.hidden)
            
        }
        .onAppear() {
            if let storedQuery = storedQuery {
                query = storedQuery
            }
        }
        .onChange(of: query) {
            lookup.update(queryFragment: query)
        }
        .padding()
    }
}
