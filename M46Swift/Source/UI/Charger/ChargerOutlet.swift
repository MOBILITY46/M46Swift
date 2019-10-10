//
//  ChargerState.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

// TODO: Charging animation

public class ChargerOutlet {
    
    public enum State: String {
        case available = "available"
        case preparing = "preparing"
        case charging = "charging"
        case suspendedEVSE = "suspendedevse"
        case suspendedEV = "suspendedev"
        case finishing = "finishing"
        case reserved = "reserved"
        case unavailable = "unavailable"
        case faulted = "faulted"
        case unknown
    }
    
    public enum Error: Swift.Error {
        case typeError(String)
    }
    
    private var transitionDuration: Double = 0.21
    private let sm: StateMachine<State>
    
    public var state: State = .unknown {
        didSet {
            sm.state = state
        }
    }
    
    public var view: UIImageView
    
    public var size: Double = 20.0 {
        didSet {
            view.frame = CGRect(x: 0, y: 0, width: size, height: size)
        }
    }

    public init (state: String = "unknown") {
        self.view = UIImageView(image: UIImage(named: "ev-socket-unavailable"))
        if let state = State(rawValue: state.lowercased()) {
            self.sm = StateMachine(state: state)
        } else {
            self.sm = StateMachine(state: .unknown)
        }
        sm.stateChanged(update)
    }
    
    private func loadImage(named img: String) {
        let bundle = Bundle(for: ChargerOutlet.self)
        if let image = UIImage(named: img, in: bundle, compatibleWith: nil) {
            self.view.image = image
        } else {
            Log.error("image named: \(img) not found")
        }
    }

    private func update(_ sm: StateMachine<State>) {
        switch sm.state {
        case .available:
            loadImage(named: "ev-socket-available")
        case .preparing:
            loadImage(named: "ev-socket-connected")
        case .charging:
            loadImage(named: "ev-socket-charging")
        case .suspendedEV:
            loadImage(named: "ev-socket-suspended")
        case .suspendedEVSE:
            loadImage(named: "ev-socket-suspended")
        case .finishing:
            loadImage(named: "ev-socket-connected")
        case .reserved:
            loadImage(named: "ev-socket-reserved")
        case .unavailable:
            loadImage(named: "ev-socket-unavailable")
        case .faulted:
            loadImage(named: "ev-socket-faulted")
        case .unknown:
            loadImage(named: "ev-socket-unavailable")
        }
    }
}
