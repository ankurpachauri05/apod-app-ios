//
//  CacheManager_Tests.swift
//  APODTests
//
//  Created by Pachauri, Ankur on 03/07/23.
//

import XCTest
import SwiftUI
@testable import APOD

final class CacheManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try resetCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func resetCache() throws {
        try CacheManager.shared.clearAllCache()
    }
    
    // MARK: Caching Value...
    
    private func isDataCached<T: Decodable>(forKey key: String, resultModel: T.Type) -> Bool {
        do {
            let result: T? = try CacheManager.shared.cachedValue(forKey: key)
            
            return result != nil
        } catch {
            return false
        }
    }

    func test_cacheValue_With_PictureDataAndEmptyKey_Returns_Failure() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = ""
        
        // ACT
        do {
            try CacheManager.shared.cacheValue(data, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? CachingError, .invalidKey)
    }
    
    func test_cacheValue_With_PictureDataAndValidKey_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        // ACT
        do {
            try CacheManager.shared.cacheValue(data, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isDataCached(forKey: key, resultModel: AstronomyPicture.self))
    }
    
    func test_cacheValue_With_CachedPictureDataAndValidKey_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        try? CacheManager.shared.cacheValue(data, forKey: key)
        
        // ACT
        do {
            try CacheManager.shared.cacheValue(data, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isDataCached(forKey: key, resultModel: AstronomyPicture.self))
    }
    
    func test_cachedValue_With_EmptyKey_Returns_Failure() {
        // ARRANGE
        var thrownError: Error?
        let key = ""
        
        // ACT
        do {
            let _: AstronomyPicture? = try CacheManager.shared.cachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? CachingError, .invalidKey)
    }
    
    func test_cachedValue_With_NoCachedPictureData_Returns_Nil() {
        // ARRANGE
        var thrownError: Error?
        var result: AstronomyPicture?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        // ACT
        do {
            result = try CacheManager.shared.cachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertNil(result)
    }
    
    func test_cachedValue_With_CachedPictureData_Returns_Data() {
        // ARRANGE
        var thrownError: Error?
        var result: AstronomyPicture?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        try? CacheManager.shared.cacheValue(data, forKey: key)
        
        // ACT
        do {
            result = try CacheManager.shared.cachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertNotNil(result)
    }

    // MARK: Caching Image...
    
    private func isImageCached(forKey key: String) -> Bool {
        do {
            let image: Image? = try CacheManager.shared.cachedImage(forKey: key)
            
            return image != nil
        } catch {
            return false
        }
    }

    func test_cacheImage_With_ImageAndEmptyKey_Returns_Failure() async {
        // ARRANGE
        var thrownError: Error?
        let image: Image = Image("placeholder")
        let key = ""
        
        // ACT
        do {
            try await CacheManager.shared.cacheImage(image, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? CachingError, .invalidKey)
    }
    
    func test_cacheImage_With_ImageAndValidKey_Returns_Success() async {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let image: Image = Image("placeholder")
        let key = "\(data.date)_image"
        
        // ACT
        do {
            try await CacheManager.shared.cacheImage(image, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isImageCached(forKey: key))
    }
    
    func test_cacheImage_With_CachedImageAndValidKey_Returns_Success() async {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let image: Image = Image("placeholder")
        let key = "\(data.date)_image"
        
        try? await CacheManager.shared.cacheImage(image, forKey: key)
        
        // ACT
        do {
            try await CacheManager.shared.cacheImage(image, forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isImageCached(forKey: key))
    }
    
    func test_cachedImage_With_EmptyKey_Returns_Failure() {
        // ARRANGE
        var thrownError: Error?
        let key = ""
        
        // ACT
        do {
            _ = try CacheManager.shared.cachedImage(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? CachingError, .invalidKey)
    }
    
    func test_cachedImage_With_NoCachedImage_Returns_Nil() {
        // ARRANGE
        var thrownError: Error?
        var image: Image?
        let data = AstronomyPicture.mockData()
        let key = "\(data.date)_image"
        
        // ACT
        do {
            image = try CacheManager.shared.cachedImage(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertNil(image)
    }
    
    func test_cachedImage_With_CachedImage_Returns_Image() async {
        // ARRANGE
        var thrownError: Error?
        var resultImage: Image?
        let image: Image = Image("placeholder")
        let data = AstronomyPicture.mockData()
        let key = "\(data.date)_image"
        
        try? await CacheManager.shared.cacheImage(image, forKey: key)
        
        // ACT
        do {
            resultImage = try CacheManager.shared.cachedImage(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertNotNil(resultImage)
    }
    
    // MARK: Remove Cache by key...
    
    func test_removeCachedValue_With_EmptyKey_Returns_Failure() {
        // ARRANGE
        var thrownError: Error?
        let key = ""
        
        // ACT
        do {
            try CacheManager.shared.removeCachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError as? CachingError, .invalidKey)
    }
    
    func test_removeCachedValue_With_ValidKeyAndNoCachedData_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        // ACT
        do {
            try CacheManager.shared.removeCachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertFalse(isDataCached(forKey: key, resultModel: AstronomyPicture.self))
    }
    
    func test_removeCachedValue_With_ValidKeyAndCachedData_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        try? CacheManager.shared.cacheValue(data, forKey: key)
        
        // ACT
        do {
            try CacheManager.shared.removeCachedValue(forKey: key)
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertFalse(isDataCached(forKey: key, resultModel: AstronomyPicture.self))
    }
    
    // MARK: Clear all cache's...
    
    private func isCacheDirectoryEmpty() -> Bool {
        do {
            let fileManager = FileManager.default
            let directoryURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            let cacheDirectoryURL = directoryURLs[0].appendingPathComponent("FileCache")
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: [])
            
            return fileURLs.isEmpty
        } catch {
            return false
        }
    }
    
    func test_clearAllCache_With_NoCachedData_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        
        // ACT
        do {
            try CacheManager.shared.clearAllCache()
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isCacheDirectoryEmpty())
    }
    
    func test_clearAllCache_With_CachedData_Returns_Success() {
        // ARRANGE
        var thrownError: Error?
        let data = AstronomyPicture.mockData()
        let key = data.date
        
        try? CacheManager.shared.cacheValue(data, forKey: key)
        
        // ACT
        do {
            try CacheManager.shared.clearAllCache()
        } catch {
            thrownError = error
        }
        
        // ASSERT
        XCTAssertNil(thrownError)
        XCTAssertTrue(isCacheDirectoryEmpty())
    }
}
