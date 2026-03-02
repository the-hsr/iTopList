//
//  APIRequest.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

protocol APIRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
}

extension APIRequest {
    var baseURL: URL {
        URL(string: "https://itunes.apple.com")!
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var headers: [String: String]? {
        nil
    }

    var body: Data? {
        nil
    }

    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringLocalCacheData
    }

    var timeoutInterval: TimeInterval {
        30.0
    }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        request.httpBody = body

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
