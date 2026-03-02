//
//  ImageLoaderTests.swift
//  iTopListTests
//
//  Created by Himanshu Singh on 02/03/26.
//

import XCTest
@testable import iTopList

final class ImageLoaderTests: XCTestCase {
    var loader: ImageLoader!
    var mockCache: MockDiskCache!
    
    override func setUp() {
        super.setUp()
        loader = ImageLoader.shared
        loader.clearMemoryCache()
        loader.clearDiskCache()
        mockCache = MockDiskCache()
    }
    
    override func tearDown() {
        loader.clearMemoryCache()
        loader.clearDiskCache()
        super.tearDown()
    }
    
    func testClearMemoryCache() {
        // Given
        let expectation = expectation(description: "Clear memory cache")
        
        // When
        loader.clearMemoryCache()
        
        // Then
        XCTAssertNoThrow(loader.clearMemoryCache())
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadImageWithInvalidURL() async {
        // Given
        let invalidURL = URL(string: "https://invalid.url/image.jpg")!
        
        // When
        let image = await loader.loadImage(from: invalidURL)
        
        // Then
        XCTAssertNil(image, "Should return nil for invalid URL")
    }
    
    func testPreloadImages() {
        // Given
        let urls = [
            URL(string: "https://test.com/icon1.png")!,
            URL(string: "https://test.com/icon2.png")!,
            URL(string: "https://test.com/icon3.png")!
        ]
        
        // When
        loader.preloadImages(urls: urls)
        
        // Then - Just verify no crashes
        XCTAssertTrue(true)
    }
}
