//
//  AppStoreResponse.swift
//  M46Swift
//
//  Created by David Jobe on 2020-06-30.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

public struct AppStoreResponse : Decodable {
    let version: SemVer

    private enum Key : CodingKey {
        case results
        case version
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
            .nestedContainer(keyedBy: Key.self, forKey: .results)
        let versionStr = try container.decode(String.self, forKey: .version)
        version = try SemVer.parse(versionStr)
    }
}
