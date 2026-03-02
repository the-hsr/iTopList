//
//  MockAPIClient.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import Foundation
@testable import iTopList

// MARK: - Mock API Client
final class MockAPIClient: APIClientProtocol {
    // MARK: - Properties
    var mockApps: [AppEntry]?
    var mockError: Error?
    var fetchCalled = false
    var fetchCallCount = 0
    
    // MARK: - Protocol Methods
    func fetchApps() async throws -> [AppEntry] {
        fetchCalled = true
        fetchCallCount += 1
        
        if let error = mockError {
            throw error
        }
        
        return mockApps ?? []
    }
    
    // MARK: - Helper Methods
    func reset() {
        mockApps = nil
        mockError = nil
        fetchCalled = false
        fetchCallCount = 0
    }
}
