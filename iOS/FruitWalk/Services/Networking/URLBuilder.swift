//
//  URLBuilder.swift
//  FruitWalk
//
//  Created by Claire S on 6/26/25.
//

import Foundation


/// A utility class to construct URLs from base URLs, path components, and query parameters.
class URLBuilder {

    private var baseURL: String
    
    // Array to store individual path components
    private var pathComponents: [String] = []
    
    // Dictionary to store query parameters
    fileprivate var queryParameters: [String: String] = [:]

    /// Initializes the URL builder with a base URL
    /// - Parameter baseURL: The root URL (without trailing slash)
    init(baseURL: String) {
        // Trim any trailing slash to ensure clean path appending
        self.baseURL = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    /// Adds a path component to the URL
    /// - Parameter component: A single path segment (e.g., "users", "profile")
    /// - Returns: The same URLBuilder instance (for chaining)
    @discardableResult
    func addPathComponent(_ component: String) -> URLBuilder {
        // Trim slashes to avoid duplicates
        let cleaned = component.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        pathComponents.append(cleaned)
        return self
    }

    /// Adds a query parameter to the URL
    /// - Parameters:
    ///   - key: The name of the query parameter
    ///   - value: The value of the query parameter
    /// - Returns: The same URLBuilder instance (for chaining)
    @discardableResult
    func addQueryParameter(key: String, value: String) -> URLBuilder {
        queryParameters[key] = value
        return self
    }

    /// Builds the final `URL` object from the base URL, path components, and query parameters
    /// - Returns: A fully constructed URL, or `nil` if the URL is invalid
    func build() -> URL? {
        // Start with the base URL
        var components = URLComponents(string: baseURL)
        
        // Join path components with `/` to form the path
        let fullPath = pathComponents.joined(separator: "/")
        components?.path = "/" + fullPath

        // Convert query parameters dictionary into an array of `URLQueryItem`
        if !queryParameters.isEmpty {
            components?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        // Return the final URL
        return components?.url
    }
}

/// Adds application default parameters
/// - Returns: The same URLBuilder instance (for chaining)
extension URLBuilder {
    
    @discardableResult
    public func addDefaultParameter() -> URLBuilder {
        queryParameters[Query.apiKey] = Query.apiValue
        queryParameters[Query.localeKey] = Query.localeValue
        return self
    }
}
