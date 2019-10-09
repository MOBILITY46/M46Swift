//
//  Localized.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
