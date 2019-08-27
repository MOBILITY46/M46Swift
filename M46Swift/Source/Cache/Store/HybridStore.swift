//
//  HybridStore.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public class HybridStore<T> {
    let memory: MemoryStore<T>
    let disk: DiskStore<T>
    
    private (set) var valueObservations = [UUID: (HybridStore, ValueChange) -> Void]()
    private (set) var keyObservations = [String: (HybridStore, KeyChange<T>) -> Void]()
    
    public init(memory: MemoryStore<T>, disk: DiskStore<T>) {
        self.memory = memory
        self.disk = disk
        
        disk.onRemove = { [weak self] path in
            self?.notifyObserver(about: .remove) { key in
                let fileName = disk.makeFileName(for: key)
                return path.contains(fileName)
            }
        }
    }
}

extension HybridStore {
    func transform<U>(transformer: Transformer<U>) -> HybridStore<U> {
        let store = HybridStore<U>(
            memory: memory.transform(transformer: transformer),
            disk: disk.transform(transformer: transformer)
        )
        return store
    }
}

extension HybridStore: StoreAware {
    public func entry(forKey key: String) throws -> Entry<T> {
        do {
            return try memory.entry(forKey: key)
        } catch {
            let entry = try disk.entry(forKey: key)
            memory.add(entry.object, forKey: key, expiry: entry.expiry)
            return entry
        }
    }
    
    public func add(_ object: T, forKey key: String, expiry: Expiry?) throws {
        var keyChange: KeyChange<T>?
        
        if keyObservations[key] != nil {
            keyChange = .edit(before: try? self.object(forKey: key), after: object)
        }
        
        memory.add(object, forKey: key, expiry: expiry)
        try disk.add(object, forKey: key, expiry: expiry)
        
        if let change = keyChange {
            notifyObserver(forKey: key, about: change)
        }
        
        notifyValueObservers(about: .add(key: key))
    }
    
    public func remove(forKey key: String) throws {
        memory.remove(forKey: key)
        try disk.remove(forKey: key)
        notifyValueObservers(about: .remove(key: key))
    }
    
    public func removeAll() throws {
        memory.removeAll()
        try disk.removeAll()
        notifyValueObservers(about: .removeAll)
    }
    
    public func removeExpired() throws {
        memory.removeExpired()
        try disk.removeExpired()
        notifyValueObservers(about: .removeExpired)
    }
}

extension HybridStore: StoreObserver {
    typealias S = HybridStore

    func addKeyObserver<O>(
        _ observer: O,
        forKey key: String,
        closure: @escaping (O, HybridStore<T>, KeyChange<T>) -> Void)
        -> ObservationToken where O: AnyObject {
            keyObservations[key] = { [weak self, weak observer] store, change in
                guard let observer = observer else {
                    self?.keyObservations.removeValue(forKey: key)
                    return
                }
                closure(observer, store, change)
            }
            
            return ObservationToken { [weak self] in
                self?.keyObservations.removeValue(forKey: key)
            }
    }
    
    func addValueObserver<O>(
        _ observer: O,
        closure: @escaping (O, HybridStore<T>, ValueChange) -> Void)
        -> ObservationToken where O: AnyObject {
            let id = UUID()
            valueObservations[id] = { [weak self, weak observer] store, change in
                guard let observer = observer else {
                    self?.valueObservations.removeValue(forKey: id)
                    return
                }
                closure(observer, store, change)
            }
            return ObservationToken { [weak self] in
                self?.valueObservations.removeValue(forKey: id)
            }
        
    }
    
    func removeObservers() {
        valueObservations.removeAll()
        keyObservations.removeAll()
    }
    
    
    private func notifyObserver(forKey key: String, about change: KeyChange<T>) {
        keyObservations[key]?(self, change)
    }
    
    private func notifyObserver(about change: KeyChange<T>, whereKey closure: ((String) -> Bool)) {
        let observation = keyObservations.first { key, _ in closure(key) }?.value
        observation?(self, change)
    }
    
    private func notifyKeyObservers(about change: KeyChange<T>) {
        keyObservations.values.forEach { closure in
            closure(self, change)
        }
    }
    
    private func notifyValueObservers(about change: ValueChange) {
        valueObservations.values.forEach { closure in
            closure(self, change)
        }
    }
}
