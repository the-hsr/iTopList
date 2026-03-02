//
//  ImageLoader.swift
//  iTopList
//
//  Created by Himanshu Singh on 02/03/26.
//


import AppKit
import Combine

final class ImageLoader {
    static let shared = ImageLoader()

    private let memoryCache = NSCache<NSURL, NSImage>()
    private let diskCache = DiskCache()
    private var loadingTasks: [URL: Task<NSImage?, Never>] = [:]
    private let loadingQueue = DispatchQueue(label: "com.itoplist.imageloader", qos: .userInitiated)

    private init() {
        memoryCache.countLimit = 200
        memoryCache.totalCostLimit = 100 * 1024 * 1024

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearMemoryCache),
            name: NSNotification.Name("NSApplicationDidReceiveMemoryWarningNotification"),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadImage(from url: URL) async -> NSImage? {
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            return cachedImage
        }

        if let diskImage = await loadFromDisk(url) {
            return diskImage
        }

        if let existingTask = loadingTasks[url] {
            return await existingTask.value
        }

        let task = Task<NSImage?, Never> { [weak self] in
            return await self?.loadFromNetwork(url)
        }

        loadingTasks[url] = task

        let image = await task.value
        loadingTasks.removeValue(forKey: url)

        return image
    }

    func preloadImages(urls: [URL]) {
        for url in urls {
            Task.detached(priority: .background) { [weak self] in
                _ = await self?.loadImage(from: url)
            }
        }
    }

    @objc func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }

    func clearDiskCache() {
        diskCache.clear()
    }

    private func loadFromDisk(_ url: URL) async -> NSImage? {
        let cacheKey = url.absoluteString

        return await Task.detached(priority: .background) { [weak self] in
            guard let diskData = await self?.diskCache.load(key: cacheKey),
                  let image = NSImage(data: diskData) else {
                return nil
            }

            await MainActor.run {
                self?.memoryCache.setObject(image, forKey: url as NSURL)
            }

            return image
        }
        .value
    }

    private func loadFromNetwork(_ url: URL) async -> NSImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = NSImage(data: data) else {
                return nil
            }

            let cacheKey = url.absoluteString
            diskCache.save(data: data, key: cacheKey)
            memoryCache.setObject(image, forKey: url as NSURL)

            return image
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
            return nil
        }
    }
}
