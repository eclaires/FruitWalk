//
//  MapSheet.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation

/// Simple object to track with one observered variable which sheet to show
/// Also tracks the last shown sheet which can be used on dismiss
/// Not a coordinator because the constructor of each sheet requires environment variables and bindings
/// Did try to construct this object with binding to all the properites which need to be tracked and set
/// but had problems passing an Environment object's observed property
@Observable class MapSheet {
    var sheet:Sheet? = nil {
        didSet {
            lastSHownSheet = oldValue
        }
    }
    @ObservationIgnored var lastSHownSheet:Sheet? = nil
    
    enum Sheet: String, Identifiable {
        case detail
        case list
        case search
        
        var id: String { rawValue }
    }
}
