//
//  AppListViewModelTests.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import XCTest
@testable import iTopList

@MainActor
final class AppListViewModelTests: XCTestCase {
    var viewModel: AppListViewModel!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        viewModel = AppListViewModel(api: mockAPIClient)
    }

    override func tearDown() {
        mockAPIClient.reset()
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertTrue(viewModel.visibleApps.isEmpty)
        XCTAssertNil(viewModel.selectedApp)
        XCTAssertFalse(viewModel.showDetail)
        XCTAssertFalse(viewModel.isGrid)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.state, .loading)
    }

    func testLoad_Success() async {
        let mockApps = TestData.createMockApps(count: 5)
        mockAPIClient.mockApps = mockApps

        viewModel.load()

        let expectation = XCTestExpectation(description: "Wait for load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertFalse(viewModel.visibleApps.isEmpty)
        XCTAssertEqual(viewModel.visibleApps.count, min(5, viewModel.pageSize))
    }

    func testLoad_Failure() async {
        mockAPIClient.mockError = NetworkError.noInternetConnection

        viewModel.load()

        let expectation = XCTestExpectation(description: "Wait for load failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        if case .failed(let message) = viewModel.state {
            XCTAssertTrue(message.contains("internet") || message.contains("connection"))
        } else {
            XCTFail("Expected failed state, got \(viewModel.state)")
        }
    }

    func testSearchFiltering() async {
        let mockApps = [
            TestData.createMockApp(name: "Minecraft"),
            TestData.createMockApp(name: "Geometry Dash"),
            TestData.createMockApp(name: "Heads Up!")
        ]
        mockAPIClient.mockApps = mockApps
        viewModel.allApps = mockApps

        viewModel.searchText = "Mine"
        viewModel.applySearch()

        let expectation = XCTestExpectation(description: "Wait for search")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        let filtered = viewModel.filteredApps
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.displayName, "Minecraft")
    }

    func testSearchWithEmptyText() async {
        let mockApps = TestData.createMockApps(count: 10)
        viewModel.allApps = mockApps
        viewModel.searchText = ""

        viewModel.applySearch()

        let expectation = XCTestExpectation(description: "Wait for search")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.filteredApps.count, 10)
    }

    func testPaginationStopsAtEnd() async {
        let mockApps = TestData.createMockApps(count: 25)
        viewModel.allApps = mockApps
        viewModel.resetPagination()
        viewModel.loadNextPage()

        var expectation = XCTestExpectation(description: "Wait for first page")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        XCTAssertEqual(viewModel.visibleApps.count, 20)

        if let lastItem = viewModel.visibleApps.last {
            viewModel.loadNextPageIfNeeded(currentItem: lastItem)
        }

        expectation = XCTestExpectation(description: "Wait for second page")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        if let lastItem = viewModel.visibleApps.last {
            viewModel.loadNextPageIfNeeded(currentItem: lastItem)
        }

        expectation = XCTestExpectation(description: "Wait for no load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        XCTAssertEqual(viewModel.visibleApps.count, 25)
    }

    func testResetPagination() async {
        let mockApps = TestData.createMockApps(count: 30)
        viewModel.allApps = mockApps
        viewModel.loadNextPage()

        let expectation = XCTestExpectation(description: "Wait for load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        XCTAssertFalse(viewModel.visibleApps.isEmpty)

        viewModel.resetPagination()

        XCTAssertTrue(viewModel.visibleApps.isEmpty)
        XCTAssertEqual(viewModel.currentPage, 0)
    }
    
    func testSelectApp() async {
        let app = TestData.createMockApp()

        viewModel.selectApp(app, fromGrid: false)

        let expectation = XCTestExpectation(description: "Wait for selection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        XCTAssertEqual(viewModel.selectedApp?.id, app.id)
        XCTAssertFalse(viewModel.showDetail)

        viewModel.selectApp(app, fromGrid: true)

        let expectation2 = XCTestExpectation(description: "Wait for selection")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation2], timeout: 0.5)

        XCTAssertEqual(viewModel.selectedApp?.id, app.id)
        XCTAssertTrue(viewModel.showDetail)
    }

    func testToggleGrid() async {
        XCTAssertFalse(viewModel.isGrid)

        viewModel.toggleGrid()

        let expectation = XCTestExpectation(description: "Wait for toggle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 0.5)

        XCTAssertTrue(viewModel.isGrid)

        viewModel.toggleGrid()

        let expectation2 = XCTestExpectation(description: "Wait for toggle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation2], timeout: 0.5)

        XCTAssertFalse(viewModel.isGrid)
    }
}
