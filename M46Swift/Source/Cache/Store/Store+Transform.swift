//
//  Store+Transform.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public extension AsyncStore {
    
    // TODO: Should we handle images?
    
    func transformData() -> AsyncStore<Data> {
        let storage = transform(transformer: TransformerFactory.forData())
        return storage
    }
    
    func transformCodable<U: Codable>(ofType: U.Type) -> AsyncStore<U> {
        let storage = transform(transformer: TransformerFactory.forCodable(ofType: U.self))
        return storage
    }
}
