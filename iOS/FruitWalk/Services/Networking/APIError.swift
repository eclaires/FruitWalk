//
//  APIError.swift
//  FruitWalk
//
//  Created by Claire S on 6/26/25.
//

import Foundation

/// Defines networking and decoding error cases for API responses
enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed
    case networkError(underlying: Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .requestFailed(let code, _):
            return "Request failed with status code \(code)."
        case .decodingFailed:
            return "Failed to decode the response."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received from the server."
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
        default:
            return false
        }
    }
}

