//
//  WebAPI.swift
//  SpaceXLaunches_Snapp
//
//  Created by Amin on 7/18/23.
//

import Foundation

protocol WebAPI {
    var endpoint: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

enum WebAPIError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    
    var localizedDescription : String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .httpCode(let code): return "HTTP Error code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server."
        }
    }
}

extension WebAPIError: LocalizedError {
    var errorDescription: String? { localizedDescription }
}

extension WebAPI {
    func urlRequest(baseURL: URL?) throws -> URLRequest {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw WebAPIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
