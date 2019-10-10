//
//  ChargerState.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation
import UIKit

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

    private func animate(to toImg: UIImage?, _ completion: ((Bool) -> Void)?) {
        UIView.transition(with: view,
                          duration: transitionDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.view.image = toImg
            }, completion: completion)
    }
    
    private func update(_ sm: StateMachine<State>) {
        switch sm.state {
        case .available:
            self.view.image = UIImage(named: "ev-socket-available")
        case .preparing:
            self.view.image = UIImage(named: "ev-socket-connected")
        case .charging:
            self.view.image = UIImage(named: "ev-socket-charging")
        case .suspendedEV:
            self.view.image = UIImage(named: "ev-socket-suspended")
        case .suspendedEVSE:
            self.view.image = UIImage(named: "ev-socket-suspended")
        case .finishing:
            self.view.image = UIImage(named: "ev-socket-connected")
        case .reserved:
            self.view.image = UIImage(named: "ev-socket-reserved")
        case .unavailable:
            self.view.image = UIImage(named: "ev-socket-unavailable")
        case .faulted:
            self.view.image = UIImage(named: "ev-socket-faulted")
        case .unknown:
            self.view.image = UIImage(named: "ev-socket-unavailable")
        }
    }
}
