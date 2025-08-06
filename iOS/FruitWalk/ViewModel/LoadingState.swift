//
//  LoadingState.swift
//  FruitWalk
//
//  Created by Claire S on 7/12/25.
//

import Foundation

enum LoadingState: Equatable {
    case loading
    case loaded
    case cancelled
    case failed(APIError)
}
