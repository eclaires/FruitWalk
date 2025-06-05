//
//  URL+Wikipedia.swift
//  FruitWalk
//
//  Created by Claire S on 6/4/25.
//

import Foundation

private let WikipediaURL = "https://en.wikipedia.org/w/index.php?title=Special:Search&search="

extension URL {
    static func wikipediaURL(term: String) -> URL? {
        return URL(string: WikipediaURL + "\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
    }
}
