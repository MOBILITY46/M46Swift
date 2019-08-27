//
//  Store.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation
import Dispatch

public class AsyncStore<T>: AsyncStoreAware {
    public enum Error : Swift.Error {
        case deallocated
    }
    
    public let store: HybridStore<T>
    public let queue: DispatchQueue
    
    public init(store: HybridStore<T>, queue: DispatchQueue) {
        self.store = store
        self.queue = queue
        
    }

    public func entry(forKey key: String, _ completion: @escaping (Result<Entry<T>>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                let entry: Entry<T> = try self.store.entry(forKey: key)
                completion(Result.value(entry))
            } catch {
                completion(Result.error(error))
            }
        }
    }
    
    public func add(_ object: T, forKey key: String, expiry: Expiry?, _ completion: @escaping (Result<()>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                try self.store.add(object, forKey: key, expiry: expiry)
                completion(Result.value(()))
            } catch {
                completion(Result.error(error))
            }
        }
    }
    
    public func remove(forKey key: String, _ completion: @escaping (Result<()>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                try self.store.remove(forKey: key)
                completion(Result.value(()))
            } catch {
                completion(Result.error(error))
            }
        }
    }
    
    public func removeAll(_ completion: @escaping (Result<()>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                try self.store.removeAll()
                completion(Result.value(()))
            } catch {
                completion(Result.error(error))
            }
        }
    }
    
    public func removeExpired(_ completion: @escaping (Result<()>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                try self.store.removeExpired()
                completion(Result.value(()))
            } catch {
                completion(Result.error(error))
            }
        }
    }
}

extension AsyncStore {
    func transform<U>(transformer: Transformer<U>) -> AsyncStore<U> {
        return AsyncStore<U>(
            store: store.transform(transformer: transformer),
            queue: queue
        )
    }
}
