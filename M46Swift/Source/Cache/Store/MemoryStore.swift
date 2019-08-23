//
//  MemoryStore.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

class MemoryCapsule: NSObject {
    let object: Any
    let expiry: Expiry
    
    init(object: Any, expiry: Expiry) {
        self.object = object
        self.expiry = expiry
    }
}


public final class MemoryStore<T> {
    public enum Error: Swift.Error {
        case notFound
        case missMatchedType
    }
    
    fileprivate let cache = NSCache<NSString, MemoryCapsule>()
    fileprivate var keys = Set<String>()
    fileprivate let config: MemoryConfig
    
    public init (config: MemoryConfig) {
        self.config = config
        self.cache.countLimit = Int(config.countLimit)
        self.cache.totalCostLimit = Int(config.totalCostLimit)
    }
}

extension MemoryStore: StoreAware {
    
    func entry(forKey key: String) throws -> Entry<T> {
        guard let capsule = cache.object(forKey: NSString(string: key)) else {
            throw Error.notFound
        }
        
        guard let object = capsule.object as? T else {
            throw Error.missMatchedType
        }
        
        return Entry(object: object, expiry: capsule.expiry)
    }
    
    func add(_ object: T, forKey key: String, expiry: Expiry?) {
        let capsule = MemoryCapsule(
            object: object,
            expiry: .date(expiry?.date ?? config.expiry.date)
        )
        cache.setObject(capsule, forKey: NSString(string: key))
        keys.insert(key)
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: NSString(string: key))
        keys.remove(key)
    }
    
    func removeAll() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func removeExpired() {
        keys.forEach { key in
            if let capsule = cache.object(forKey: NSString(string: key)),
                capsule.expiry.isExpired {
                remove(forKey: key)
            }
        }
    }
}

extension MemoryStore {
    func transform<U>(transformer: Transformer<U>) -> MemoryStore<U> {
        let store = MemoryStore<U>(config: self.config)
        return store
    }
}
