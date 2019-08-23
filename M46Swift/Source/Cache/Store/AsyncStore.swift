//
//  Store.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation
import Dispatch

public final class AsyncStore<T> {
    public enum Error : Swift.Error {
        case deallocated
    }
    
    public let store: HybridStore<T>
    public let queue: DispatchQueue
    
    public init(store: HybridStore<T>, queue: DispatchQueue) {
        self.store = store
        self.queue = queue
        
    }
}

extension AsyncStore {
    
    func entry(forKey key: String, completion: @escaping (Result<Entry<T>>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(Result.error(Error.deallocated))
                return
            }
            
            do {
                let entry = try self.store.entry(forKey: key)
                completion(Result.value(entry))
            } catch {
                completion(Result.error(error))
            }
        }
    }
    
    func add(_ object: T, forKey key: String, expiry: Expiry?, completion: @escaping (Result<()>) -> Void) {
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
    
    func remove(forKey key: String, completion: @escaping (Result<()>) -> Void) {
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
    
    func removeAll(completion: @escaping (Result<()>) -> Void) {
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
    
    func removeExpired(completion: @escaping (Result<()>) -> Void) {
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
    
    func object(forKey key: String, completion: @escaping (Result<T>) -> Void) {
        entry(forKey: key, completion: { (result: Result<Entry<T>>) in
            completion(result.map { $0.object })
        })
    }
    
    func exists(forKey key: String, completion: @escaping (Result<Bool>) -> Void) {
        object(forKey: key, completion: { (result: Result<T>) in
            completion(result.map { _ in true })
        })
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
