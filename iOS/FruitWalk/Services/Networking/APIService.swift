//
//  FruitRequest.swift
//  FruitWalk
//
//  Created by Claire S on 6/23/25.
//

import Foundation

/// RESTful API client using async/await and strong error handling
class APIService {
    static let shared = APIService()
    
    private let decoder = JSONDecoder()
    private let session: URLSession!
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session  = URLSession.init(configuration: configuration)
    }

    /// Sends an API request and returns a decoded object or a structured error
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async -> Result<T, APIError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            // Make the request
            let (data, response) = try await session.data(for: request)

            // Validate HTTP response
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                return .failure(.requestFailed(statusCode: httpResponse.statusCode, data: data))
            }

            // Ensure data is not empty
            guard !data.isEmpty else {
                return .failure(.noData)
            }

            // Decode the data
            let decoded = try self.decoder.decode(responseType, from: data)
            return .success(decoded)

        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            return .failure(.decodingFailed)
        } catch {
            return .failure(.networkError(underlying: error))
        }
    }
}
