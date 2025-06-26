//
//  MapItemProtocol.swift
//  FruitWalk
//
//  Created by Claire S on 5/8/25.
//

import Foundation
import MapKit
import SwiftUI

protocol MapItem {
    var displayName: String { get }
    var identifier: Int { get }
    var coordinate: CLLocationCoordinate2D { get }

    // @ViewBuilder can't be used in protocol method declarations
    func annotationView(count: Int, isSelected: Bool, hide: Bool) -> AnyView
}
