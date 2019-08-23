//
//  StoreObserver.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

protocol StoreObserver {
    associatedtype S: StoreAware

    func addValueObserver<O: AnyObject>(
        _ observer: O,
        closure: @escaping (O, S, ValueChange) -> Void
    ) -> ObservationToken
    
    func addKeyObserver<O: AnyObject>(
        _ observer: O,
        forKey key: String,
        closure: @escaping (O, S, KeyChange<S.T>) -> Void
    ) -> ObservationToken
    
    func removeObservers()
}

enum ValueChange: Equatable {
    case add(key: String)
    case remove(key: String)
    case removeAll
    case removeExpired
    
    public static func == (lhs: ValueChange, rhs: ValueChange) -> Bool {
        switch (lhs, rhs) {
        case (.add(let key1), .add(let key2)), (.remove(let key1), .remove(let key2)):
            return key1 == key2
        case (.removeAll, .removeAll), (.removeExpired, .removeExpired):
            return true
        default:
            return false
        }
    }
}

public enum KeyChange<T> {
    case edit(before: T?, after: T)
    case remove
}

extension KeyChange: Equatable where T: Equatable {
    
    public static func == (lhs: KeyChange<T>, rhs: KeyChange<T>) -> Bool {
        switch (lhs, rhs) {
        case (.edit(let before1, let after1), .edit(let before2, let after2)):
            return before1 == before2 && after1 == after2
        case (.remove, .remove):
            return true
        default:
            return false
        }
    }
}

public final class ObservationToken {
    private let cancellationClosure: () -> Void
    
    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }
    
    public func cancel() {
        cancellationClosure()
    }
}
