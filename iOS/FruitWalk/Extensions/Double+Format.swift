//
//  Double+Format.swift
//  FruitWalk
//
//  Created by Claire S on 3/26/25.
//

import Foundation

extension Double {
    func formattedDistance() -> String {
        if self >= 1000 {
            return String(format: "%.1fmi %.1fm", (self / 1609) + 0.05, self / 1000)
        } else {
            return String(format: "%.1fmi %.1fm", (self / 1609) + 0.05, self)
        }
    }
}
