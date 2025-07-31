//
//  MapSearch.swift
//  FruitWalk
//
//  Created by Claire S on 4/6/25.
//

import Foundation
import MapKit

@Observable
class MapSearch: NSObject, MKLocalSearchCompleterDelegate {
    @ObservationIgnored private let completer = MKLocalSearchCompleter()
    var results = [SearchResultItem]()
    
    init(completer: MKLocalSearchCompleter) {
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = [.address, .pointOfInterest]
        completer.queryFragment = queryFragment
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
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
