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
