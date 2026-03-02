//
//  DiskCache.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

class DiskCache {
    static let shared = DiskCache()

    private let baseURL: URL
    private let fileManager = FileManager.default
    private let queue = DispatchQueue(label: "com.itoplist.diskcache", qos: .utility)

    init(baseURL: URL? = nil) {
        if let baseURL = baseURL {
            self.baseURL = baseURL
        } else {
            let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            self.baseURL = cachesDirectory.appendingPathComponent("com.itoplist.cache", isDirectory: true)
        }
        
        createCacheDirectoryIfNeeded()
    }

    private func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: baseURL.path) else { return }
        
        do {
            try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create cache directory: \(error)")
        }
    }

    func save(data: Data, key: String) {
        let safeKey = sanitizeKey(key)
        let fileURL = baseURL.appendingPathComponent(safeKey)
        
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save cache: \(error)")
        }
    }

    func load(key: String) -> Data? {
        let safeKey = sanitizeKey(key)
        let fileURL = baseURL.appendingPathComponent(safeKey)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            return try Data(contentsOf: fileURL)
        } catch {
            print("Failed to load cache: \(error)")
            return nil
        }
    }

    func clear() {
        do {
            if fileManager.fileExists(atPath: baseURL.path) {
                try fileManager.removeItem(at: baseURL)
                try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Failed to clear cache: \(error)")
        }
    }

    private func sanitizeKey(_ key: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/:?&=<>|\\*\"")
        return key.components(separatedBy: invalidCharacters)
            .joined(separator: "_")
            .replacingOccurrences(of: "__", with: "_")
    }
}
