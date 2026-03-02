//
//  MockDiskCache.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import Foundation
@testable import iTopList

// MARK: - Mock Disk Cache
final class MockDiskCache: DiskCache {
    // MARK: - Properties
    private var storage: [String: Data] = [:]
    private(set) var saveCalled = false
    private(set) var loadCalled = false
    private(set) var clearCalled = false
    private(set) var lastSavedKey: String?
    private(set) var lastLoadedKey: String?
    private(set) var saveCallCount = 0
    private(set) var loadCallCount = 0
    
    // MARK: - Override Methods
    override func save(data: Data, key: String) {
        saveCalled = true
        saveCallCount += 1
        lastSavedKey = key
        storage[key] = data
    }
    
    override func load(key: String) -> Data? {
        loadCalled = true
        loadCallCount += 1
        lastLoadedKey = key
        return storage[key]
    }
    
    override func clear() {
        clearCalled = true
        storage.removeAll()
    }
    
    // MARK: - Helper Methods
    func reset() {
        storage.removeAll()
        saveCalled = false
        loadCalled = false
        clearCalled = false
        lastSavedKey = nil
        lastLoadedKey = nil
        saveCallCount = 0
        loadCallCount = 0
    }
}
