//
//  DiskCacheTests.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import XCTest
@testable import iTopList

final class DiskCacheTests: XCTestCase {
    var cache: DiskCache!
    var testURL: URL!
    
    override func setUp() {
        super.setUp()
        let tempDir = FileManager.default.temporaryDirectory
        testURL = tempDir.appendingPathComponent("test_cache_\(UUID().uuidString)")
        cache = DiskCache(baseURL: testURL)
    }

    override func tearDown() {
        cache.clear()

        try? FileManager.default.removeItem(at: testURL)

        cache = nil
        testURL = nil

        super.tearDown()
    }

    func testSaveAndLoad() {
        let testData = "Hello World".data(using: .utf8)!
        let key = "test_key"

        cache.save(data: testData, key: key)
        let loadedData = cache.load(key: key)

        XCTAssertNotNil(loadedData, "Loaded data should not be nil")
        XCTAssertEqual(loadedData, testData, "Loaded data should match saved data")
    }

    func testLoadNonExistentKey() {
        let data = cache.load(key: "non_existent_key_\(UUID().uuidString)")

        XCTAssertNil(data, "Loading non-existent key should return nil")
    }

    func testClear() {
        let testData = "Hello World".data(using: .utf8)!
        let key = "test_key_clear"
        cache.save(data: testData, key: key)

        let savedData = cache.load(key: key)
        XCTAssertNotNil(savedData, "Data should be saved before clear")

        cache.clear()

        let loadedData = cache.load(key: key)
        XCTAssertNil(loadedData, "Data should be nil after clear")
    }

    func testKeySanitization() {
        let testData = "Hello World".data(using: .utf8)!
        let key = "https://test.com/path?query=1&param=2"

        cache.save(data: testData, key: key)
        let loadedData = cache.load(key: key)

        XCTAssertNotNil(loadedData, "Data should be retrievable with original key")
        XCTAssertEqual(loadedData, testData, "Loaded data should match saved data")
    }

    func testSaveAndLoadMultipleKeys() {
        let testData1 = "Data 1".data(using: .utf8)!
        let testData2 = "Data 2".data(using: .utf8)!
        let key1 = "key1"
        let key2 = "key2"

        cache.save(data: testData1, key: key1)
        cache.save(data: testData2, key: key2)

        let loadedData1 = cache.load(key: key1)
        let loadedData2 = cache.load(key: key2)

        XCTAssertNotNil(loadedData1, "Data for key1 should exist")
        XCTAssertNotNil(loadedData2, "Data for key2 should exist")
        XCTAssertEqual(loadedData1, testData1, "Data for key1 should match")
        XCTAssertEqual(loadedData2, testData2, "Data for key2 should match")
    }

    func testOverwriteExistingKey() {
        let key = "overwrite_key"
        let originalData = "Original Data".data(using: .utf8)!
        let newData = "New Data".data(using: .utf8)!

        cache.save(data: originalData, key: key)
        let loadedOriginal = cache.load(key: key)

        XCTAssertEqual(loadedOriginal, originalData, "Original data should be saved")

        cache.save(data: newData, key: key)
        let loadedNew = cache.load(key: key)

        XCTAssertEqual(loadedNew, newData, "Data should be overwritten with new data")
        XCTAssertNotEqual(loadedNew, originalData, "New data should not equal original")
    }

    func testSpecialCharactersInKey() {
        let testData = "Test Data".data(using: .utf8)!
        let key = "key/with:special?characters&more=test"

        cache.save(data: testData, key: key)
        let loadedData = cache.load(key: key)

        XCTAssertNotNil(loadedData, "Data with special characters in key should be retrievable")
        XCTAssertEqual(loadedData, testData, "Data should match")
    }
}
