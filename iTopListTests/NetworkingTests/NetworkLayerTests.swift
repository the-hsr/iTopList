//
//  NetworkLayerTests.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import XCTest
@testable import iTopList

final class NetworkLayerTests: XCTestCase {
    var mockNetworkClient: MockNetworkClient!
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        apiClient = APIClient(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient.reset()
        super.tearDown()
    }
    
    func testTopPaidAppsRequest_ConstructsCorrectURL() throws {
        // Given
        let request = TopPaidAppsRequest()
        
        // When
        let urlRequest = try request.asURLRequest()
        
        // Then
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://itunes.apple.com/us/rss/toppaidapplications/limit=100/json")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(urlRequest.cachePolicy, .returnCacheDataElseLoad)
    }
    
    func testNetworkClient_SuccessfulResponse() async throws {
        // Given
        let mockResponse = TestData.mockRSSResponse
        mockNetworkClient.mockResult = mockResponse
        let request = TopPaidAppsRequest()
        
        // When
        let result = try await mockNetworkClient.fetch(request)
        
        // Then
        XCTAssertNotNil(mockNetworkClient.capturedRequest)
        XCTAssertEqual(result.feed.entry.count, 2)
        XCTAssertEqual(result.feed.entry.first?.name.label, "Minecraft")
    }
    
    func testNetworkClient_HandlesNetworkError() async {
        // Given
        mockNetworkClient.mockError = URLError(.notConnectedToInternet)
        let request = TopPaidAppsRequest()
        
        // When/Then
        do {
            _ = try await mockNetworkClient.fetch(request)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
    
    func testNetworkClient_HandlesUnknownError() async {
        // Given
        mockNetworkClient.mockError = NSError(domain: "test", code: -1)
        let request = TopPaidAppsRequest()
        
        // When/Then
        do {
            _ = try await mockNetworkClient.fetch(request)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
