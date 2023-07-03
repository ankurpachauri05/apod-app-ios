//
//  CacheManager.swift
//  APOD
//
//  Created by Pachauri, Ankur on 15/06/23.
//

import SwiftUI

protocol CacheManagerProtocol {
    func cacheValue<T: Encodable>(_ value: T, forKey key: String) throws
    func cachedValue<T: Decodable>(forKey key: String) throws -> T?
    func cacheImage(_ image: Image, forKey key: String) throws
    func cachedImage(forKey key: String) throws -> Image?
    func removeCachedValue(forKey key: String) throws
    func clearAllCache() throws
}

class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    
    private let cache = FileCache.shared
    
    private init() {}
    
    func cacheValue<T: Encodable>(_ value: T, forKey key: String) throws {
        guard !key.isEmpty else { throw CachingError.invalidKey }
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        
        try cache.saveData(data, forKey: key)
    }
    
    func cachedValue<T: Decodable>(forKey key: String) throws -> T? {
        guard !key.isEmpty else { throw CachingError.invalidKey }
        
        if let data = try cache.fetchData(forKey: key) {
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: data)
            
            return value
        }
        
        return nil
    }
    
    @MainActor
    func cacheImage(_ image: Image, forKey key: String) throws {
        guard !key.isEmpty else { throw CachingError.invalidKey }
        
        let renderer = ImageRenderer(content: image)
        
        if let uiImage = renderer.uiImage,
           let data = uiImage.jpegData(compressionQuality: 1.0) {
            try cache.saveData(data, forKey: key)
        }
    }
    
    func cachedImage(forKey key: String) throws -> Image? {
        guard !key.isEmpty else { throw CachingError.invalidKey }
        
        if let imageData = try cache.fetchData(forKey: key),
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
    
    func removeCachedValue(forKey key: String) throws {
        guard !key.isEmpty else { throw CachingError.invalidKey }
        
        try cache.deleteData(forKey: key)
    }
    
    func clearAllCache() throws {
        try cache.deleteAllFiles()
    }
}


final class FileCache {
    static let shared = FileCache()
    
    private let fileManager: FileManager
    private let cacheDirectoryURL: URL
    private let cacheDuration: TimeInterval = 24 * 60 * 60  // 1 day in seconds
    
    private init() {
        self.fileManager = FileManager.default
        let directoryURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectoryURL = directoryURLs[0].appendingPathComponent("FileCache")
        createCacheDirectoryIfNeeded()
        deleteFilesOlderThan(interval: cacheDuration)
    }
    
    private func createCacheDirectoryIfNeeded() {
        do {
            if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
                try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Error creating cache directory: \(error)")
        }
    }
    
    func saveData(_ data: Data, forKey key: String) throws {
        do {
            let fileURL = cacheDirectoryURL.appendingPathComponent(key)
            try data.write(to: fileURL)
        } catch {
            throw DirectoryError.savingFailed
        }
    }
    
    func fetchData(forKey key: String) throws -> Data? {
        do {
            let fileURL = cacheDirectoryURL.appendingPathComponent(key)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                
                return data
            }
            
            return nil
        } catch {
            throw DirectoryError.fetchingFailed
        }
    }
    
    func deleteData(forKey key: String) throws {
        do {
            let fileURL = cacheDirectoryURL.appendingPathComponent(key)
            
            if fileManager.fileExists(atPath: fileURL.path()) {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            throw DirectoryError.deletionFailed
        }
    }
    
    private func deleteFilesOlderThan(interval: TimeInterval) {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: [])
            let currentDate = Date()
            
            for fileURL in fileURLs {
                let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                if let creationDate = attributes[.creationDate] as? Date,
                   currentDate.timeIntervalSince(creationDate) > interval {
                    try fileManager.removeItem(at: fileURL)
                }
            }
        } catch {
            print("Error while deleting older files: \(error)")
        }
    }
    
    func deleteAllFiles() throws {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: [])
            
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            throw DirectoryError.deletionFailed
        }
    }
}
