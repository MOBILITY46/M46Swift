//
//  StoreAware.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

protocol StoreAware {
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
    
    func object(forKey key: String) throws -> T {
        return try entry(forKey: key).object
    }
    
    func exists(forKey key: String) throws -> Bool {
        do {
            let _: T = try object(forKey: key)
            return true
        } catch {
            return false
        }
    }
    
    func expired(forKey key: String) throws -> Bool {
        do {
            let e = try entry(forKey: key)
            return e.expiry.isExpired
        } catch {
            return true
        }
    }
}
