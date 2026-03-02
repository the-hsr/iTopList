//
//  APIClientTests.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import XCTest
@testable import iTopList

final class APIClientTests: XCTestCase {
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

    func testFetchApps_Success() async throws {
        let mockResponse = TestData.mockRSSResponse
        mockNetworkClient.mockResult = mockResponse

        let apps = try await apiClient.fetchApps()

        XCTAssertEqual(apps.count, 2)
        XCTAssertEqual(apps.first?.name.label, "Minecraft")
        XCTAssertEqual(apps.first?.summary.label, "Dive into an open world of building, crafting and survival.")
        XCTAssertEqual(apps.first?.iconURL?.absoluteString, "https://test.com/minecraft@2x.png")
    }

    func testFetchApps_HandlesNetworkError() async {
        mockNetworkClient.mockError = URLError(.notConnectedToInternet)

        do {
            _ = try await apiClient.fetchApps()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }

    func testFetchApps_HandlesDecodingError() async {
        mockNetworkClient.mockResult = "Invalid Data"

        do {
            _ = try await apiClient.fetchApps()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testFetchApps_CallsNetworkClientOnce() async throws {
        let mockResponse = TestData.mockRSSResponse
        mockNetworkClient.mockResult = mockResponse

        _ = try await apiClient.fetchApps()

        XCTAssertEqual(mockNetworkClient.fetchCallCount, 1)
    }
}
