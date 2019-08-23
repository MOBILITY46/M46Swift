//
//  TestHelpers.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

struct TestHelper {
    static func data(_ length : Int) -> Data {
        let buffer = [UInt8](repeating: 0, count: length)
        return Data(buffer)
    }
    
    static func triggerApplicationEvents() {
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.post(name: UIApplication.willTerminateNotification, object: nil)
    }
}
