//
//  CacheManager.swift
//  APOD
//
//  Created by Pachauri, Ankur on 15/06/23.
//

import SwiftUI

enum CachingKeys: String {
    case astronomyData
    case astronomyImage
}

class CacheManager {
    static let shared = CacheManager()
    
    private let cache = Cache<AnyObject>()
    
    private init() {}
    
    func cacheValue<T>(_ value: T, forKey key: String) {
        cache.insert(value as AnyObject, forKey: key)
    }
    
    func cachedValue<T>(forKey key: String) -> T? {
        return cache.value(forKey: key) as? T
    }
    
    func removeCachedValue(forKey key: String) {
        cache.removeValue(forKey: key)
    }
    
    func clearCache() {
        cache.clearCache()
    }
}


final class Cache<Value: AnyObject> {
    private let cache = NSCache<NSString, ValueWrapper>()
    
    func insert(_ value: Value, forKey key: String) {
        let valueWrapper = ValueWrapper(value)
        cache.setObject(valueWrapper, forKey: key as NSString)
    }
    
    func value(forKey key: String) -> Value? {
        return cache.object(forKey: key as NSString)?.value
    }
    
    func removeValue(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    private final class ValueWrapper: NSObject, NSDiscardableContent {
        let value: Value
        
        init(_ value: Value) {
            self.value = value
        }
        
        func beginContentAccess() -> Bool {
            return true
        }
        
        func endContentAccess() {
            
        }
        
        func discardContentIfPossible() {
            
        }
        
        func isContentDiscarded() -> Bool {
            return false
        }
    }
}
