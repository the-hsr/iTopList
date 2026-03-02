//
//  NetworkError.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
