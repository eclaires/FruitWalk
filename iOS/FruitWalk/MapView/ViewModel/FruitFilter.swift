//
//  FruitFilter.swift
//  FruitWalk
//
//  Created by Claire S on 4/11/25.
//

import Foundation

@Observable class FruitFilter {
    @ObservationIgnored private var names = Set<String>()
    @ObservationIgnored private var ids = Set<Int>()
    
    init(_ locations: [FruitLocation]) {
        
        for location in locations {
            for typeId in location.typeIds {
                self.ids.insert(typeId)
            }
            
            if let names = location.typeNames {
                for name in names {
                    let words = name.components(separatedBy: [",", " "])
                    for word in words {
                        self.names.insert(word.lowercased())
                    }
                }
            }
        }
    }
    
    func displayName() -> String {
        return names.joined(separator: " ")
    }
    
    func contains(_ location: FruitLocation) -> Bool {
        
        if let locationNames = location.typeNames {
            for locationName in locationNames {
                let words = locationName.components(separatedBy: [",", " "])
                for word in words {
                    if self.names.contains(word.lowercased()) {
                        return true
                    }
                }
            }
        }
        
        for id in location.typeIds {
            if self.ids.contains(id) {
                return true
            }
        }
        
        return false
    }
}
