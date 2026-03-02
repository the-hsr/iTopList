//
//  DiskCache.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import Foundation

final class DiskCache {
    static let shared = DiskCache()

    private let baseURL: URL
    private let fileManager = FileManager.default
    private let queue = DispatchQueue(label: "com.itoplist.diskcache", qos: .utility)

    init(baseURL: URL? = nil) {
        if let baseURL = baseURL {
            self.baseURL = baseURL
        } else {
            self.baseURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("iTopListCache", isDirectory: true)
        }
        
        createCacheDirectoryIfNeeded()
    }

    func save(data: Data, key: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let safeKey = self.sanitizeKey(key)
            let fileURL = self.baseURL.appendingPathComponent(safeKey)
            
            do {
                try data.write(to: fileURL)
            } catch {
                print("Failed to save cache: \(error.localizedDescription)")
            }
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
            print("Failed to load cache: \(error.localizedDescription)")
            return nil
        }
    }

    func clear() {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let contents = try self.fileManager.contentsOfDirectory(at: self.baseURL, includingPropertiesForKeys: nil)
                for url in contents {
                    try self.fileManager.removeItem(at: url)
                }
            } catch {
                print("Failed to clear cache: \(error.localizedDescription)")
            }
        }
    }

    private func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: baseURL.path) else { return }

        do {
            try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
        } catch {
            print("Failed to create cache directory: \(error.localizedDescription)")
        }
    }

    private func sanitizeKey(_ key: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return key.components(separatedBy: allowedCharacters.inverted)
            .joined(separator: "_")
    }
}
