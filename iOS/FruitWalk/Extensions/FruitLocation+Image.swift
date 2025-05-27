//
//  FruitLocation+Image.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation

extension FruitLocation {
    
    /// Ideally all fruits have a default image to fall back on when a URL is not supplied
    /// - Returns: the resource name for the default image
    func defaultImage() -> String {
        let fruitId = typeIds.first
        
        if fruitId == 10 {
            return "rosemary"
        } else if fruitId == 1 || fruitId == 441 || fruitId == 691 {
            return "plum"
        } else if fruitId == 4522 {
            return "persimmon"
        } else if fruitId == 4 || fruitId == 27 || fruitId == 5097 {
            return "lemon"
        } else {
            return "multifruit_icon"
        }
    }
}
