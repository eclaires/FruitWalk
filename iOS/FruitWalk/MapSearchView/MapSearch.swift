//
//  MapSearch.swift
//  FruitWalk
//
//  Created by Claire S on 4/6/25.
//

import Foundation
import MapKit

@Observable class MapSearch: NSObject, MKLocalSearchCompleterDelegate {
    @ObservationIgnored private let completer = MKLocalSearchCompleter()
    @ObservationIgnored private var query = ""
    var results = [SearchResultItem]()
    
    init(completer: MKLocalSearchCompleter) {
        super.init()
        self.completer.delegate = self
    }

    func update(query: String) {
        self.query = query

        // Don't search empty strings
        guard !query.isEmpty else {
            results = []
            return
        }
        // start the search
        completer.resultTypes = [.address, .pointOfInterest]
        completer.queryFragment = self.query
    }
    
    // completerDidUpdateResults is nonisolated so update results on the main thread
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        Task { @MainActor in
            guard completer.queryFragment == query else {
                return
            }
            results.removeAll()
            for completion in completer.results {
                if let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem,
                   let coordinate = mapItem.placemark.location?.coordinate
                {
                    results.append(.init(
                        title: completion.title,
                        subTitle: completion.subtitle,
                        coordinate: coordinate
                    ))
                }
            }
        }
    }
}
