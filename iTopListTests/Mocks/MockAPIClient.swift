//
//  MockAPIClient.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import Foundation
@testable import iTopList

final class MockAPIClient: APIClientProtocol {
    var mockApps: [AppEntry]?
    var mockError: Error?
    var fetchCalled = false
    var fetchCallCount = 0

    func fetchApps() async throws -> [AppEntry] {
        fetchCalled = true
        fetchCallCount += 1

        if let error = mockError {
            throw error
        }

        return mockApps ?? []
    }

    func reset() {
        mockApps = nil
        mockError = nil
        fetchCalled = false
        fetchCallCount = 0
    }
}
