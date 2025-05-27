//
//  Date+Format.swift
//  FruitWalk
//
//  Created by Claire S on 5/24/25.
//

import Foundation

extension Date {
    static func getISODate(string: String?) -> Date? {
        guard let string = string else {
            return nil
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:string)
        return date
    }
}
