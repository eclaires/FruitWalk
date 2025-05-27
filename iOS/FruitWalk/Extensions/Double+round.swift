//
//  Double+round.swift
//  FruitWalk
//
//  Created by Claire S on 2/23/25.
//

import Foundation

extension Double {
    func roundToDecimal(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
