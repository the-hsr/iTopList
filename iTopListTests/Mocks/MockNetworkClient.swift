//
//  MockNetworkClient.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import Foundation
@testable import iTopList

final class MockNetworkClient: NetworkClientProtocol {
    var mockResult: Any?
    var mockError: Error?
    var capturedRequest: Any?
    var fetchCallCount = 0

    func fetch<T: APIRequest>(_ request: T) async throws -> T.Response {
        fetchCallCount += 1
        capturedRequest = request

        if let error = mockError {
            throw error
        }

        if let result = mockResult as? T.Response {
            return result
        }

        throw NetworkError.unknown(URLError(.cannotParseResponse))
    }

    func reset() {
        mockResult = nil
        mockError = nil
        capturedRequest = nil
        fetchCallCount = 0
    }
}
