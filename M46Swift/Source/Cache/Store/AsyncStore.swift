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
        case store(Swift.Error)
    }
    
    public let store: HybridStore<T>
    public let queue: DispatchQueue
    
    public init(store: HybridStore<T>, queue: DispatchQueue) {
        self.store = store
        self.queue = queue
        
    }

    public func entry(forKey key: String, _ completion: @escaping (Result<Entry<T>, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.deallocated))
                return
            }
            
            do {
                let entry = try self.store.entry(forKey: key)
                completion(.success(entry))
            } catch {
                completion(.failure(.store(error)))
            }
        }
    }
    
    public func add(_ object: T, forKey key: String, expiry: Expiry?, _ completion: @escaping (Result<(), Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.deallocated))
                return
            }
            
            do {
                try self.store.add(object, forKey: key, expiry: expiry)
                completion(.success(()))
            } catch {
                completion(.failure(.store(error)))
            }
        }
    }
    
    public func remove(forKey key: String, _ completion: @escaping (Result<(), Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.deallocated))
                return
            }
            
            do {
                try self.store.remove(forKey: key)
                completion(.success(()))
            } catch {
                completion(.failure(.store(error)))
            }
        }
    }
    
    public func removeAll(_ completion: @escaping (Result<(), Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.deallocated))
                return
            }
            
            do {
                try self.store.removeAll()
                completion(.success(()))
            } catch {
                completion(.failure(.store(error)))
            }
        }
    }
    
    public func removeExpired(_ completion: @escaping (Result<(), Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.deallocated))
                return
            }
            
            do {
                try self.store.removeExpired()
                completion(.success(()))
            } catch {
                completion(.failure(.store(error)))
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
