//
//  APIError.swift
//  FruitWalk
//
//  Created by Claire S on 6/26/25.
//

import Foundation

/// Defines networking and decoding error cases for API responses
/// Conforming to the Error protocol so it can be catchable in a catch statement
enum APIError: Error {
    case invalidURL
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed
    case networkError(underlying: Error)
    case noData
    case lookAroundUnavailable
    
    // TODO: Localize
    var localizedErrorTitleAndDescription: (title: String, description: String) {
        switch self {
        case .invalidURL:
            return ("Network Error", "Invalid URL")
        case .requestFailed(let code, _):
            return ("Network Error", "The request failed with status code \(code)")
        case .decodingFailed:
            return ("Decoding Error", "Failed to decode server data.")
        case .networkError(let error):
            return ("Network Error", "\(error.localizedDescription)")
        case .noData:
            return ("No Data", "Data was not received from the server.")
        case .lookAroundUnavailable:
            return ("Street View", "Unable to look around this location.")
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.requestFailed(let lStatusCode, _), .requestFailed(let rStatusCode, _)):
            return lStatusCode == rStatusCode
        case (.decodingFailed, .decodingFailed):
            return true
        case (.networkError(let lError), .networkError(let rError)):
            return lError.localizedDescription == rError.localizedDescription
        case (.noData, .noData):
            return true
        case (.lookAroundUnavailable, .lookAroundUnavailable):
            return true
        default:
            return false
        }
    }
}

