//
//  StoreAware.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public protocol StoreAware {
    associatedtype T
    
    func object(forKey key: String) throws -> T
    
    func entry(forKey key: String) throws -> Entry<T>
    
    func add(_ object: T, forKey key: String, expiry: Expiry?) throws
    
    func remove(forKey key: String) throws
    
    func removeAll() throws
    
    func removeExpired() throws
    
    func exists(forKey key: String) throws -> Bool
    
    func expired(forKey key: String) throws -> Bool
}

extension StoreAware {
    
    public func object(forKey key: String) throws -> T {
        return try entry(forKey: key).object
    }
    
    public func exists(forKey key: String) throws -> Bool {
        do {
            let _: T = try object(forKey: key)
            return true
        } catch {
            return false
        }
    }
    public   
    func expired(forKey key: String) throws -> Bool {
        do {
            let e = try entry(forKey: key)
            return e.expiry.isExpired
        } catch {
            return true
        }
    }
}

public protocol AsyncStoreAware {
    associatedtype T

    func entry(forKey key: String, _ completion: @escaping (_ result: Result<Entry<T>>) -> Void)
    
    func add(_ object: T, forKey key: String, expiry: Expiry?, _ completion: @escaping (_ result: Result<()>) -> Void)
    
    func remove(forKey key: String, _ completion: @escaping (_ result: Result<()>) -> Void)
    
    func removeAll(_ completion: @escaping (_ result: Result<()>) -> Void)
    
    func removeExpired(_ completion: @escaping (_ result: Result<()>) -> Void)
    
    func object(forKey key: String, _ completion: @escaping (_ result: Result<T>) -> Void)
    
    func exists(forKey key: String, _ completion: @escaping (_ result: Result<Bool>) -> Void)
    
    func expired(forKey key: String, _ completion: @escaping (_ result: Result<Bool>) -> Void)
}

extension AsyncStoreAware {
    
    public func object(forKey key: String, _ completion: @escaping (Result<T>) -> Void) {
        entry(forKey: key, { (result: Result<Entry<T>>) in
            completion(result.map { $0.object })
        })
    }
    
    public func exists(forKey key: String, _ completion: @escaping (Result<Bool>) -> Void) {
        object(forKey: key, { (result: Result<T>) in
            completion(result.map { _ in true })
        })
    }
    
    public func expired(forKey key: String, _ completion: @escaping (_ result: Result<Bool>) -> Void) {
        entry(forKey: key, { (result: Result<Entry<T>>) in
            completion(result.map { $0.expiry.isExpired })
        })
    }

}


