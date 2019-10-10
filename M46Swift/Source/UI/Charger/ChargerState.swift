//
//  ChargerState.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

public class ChargerOutlet {
    
    public enum State: String {
        case available = "Available"
        case preparing = "Preparing"
        case charging = "Charging"
        case suspendedEVSE = "SuspendedEVSE"
        case suspendedEV = "SuspendedEV"
        case finishing = "Finishing"
        case reserved = "Reserved"
        case unavailable = "Unavailable"
        case faulted = "Faulted"
        case unknown
    }
    
    private var transitionDuration: Double = 0.21
    
    var imageView: UIImageView

    var size: Double = 20.0 {
        didSet {
            imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        }
    }
    
    var state: State {
        sm.state
    }

    private let sm: StateMachine<State>
    
    public init (_ sm: StateMachine<State> = StateMachine(state: .unknown)) {
        self.sm = sm
        self.imageView = UIImageView(image: UIImage(named: "ev-socket"))
        sm.stateChanged(update)
    }
    
    func set(_ value: String) {
        if let state = State(rawValue: value) {
            sm.state = state
        } else {
            sm.state = .unknown
        }
    }
    
    func set(_ value: State) {
        sm.state = value
    }
    
    private func animate(to toImg: UIImage?, _ completion: ((Bool) -> Void)?) {
        UIView.transition(with: imageView,
                          duration: transitionDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.imageView.image = toImg
            }, completion: completion)
    }
    
    private func update(_ sm: StateMachine<State>) {
        switch sm.state {
        case .available:
            self.animate(to: UIImage(named: "ev-socket"), nil)
        case .preparing:
            transitionDuration = 0.21
            self.animate(to: UIImage(named: "ev-socket-connected-1"), { _ in
                self.animate(to: UIImage(named: "ev-socket-connected-2"), { _ in
                    self.animate(to: UIImage(named: "ev-socket-connected-3"), { _ in
                        self.animate(to: UIImage(named: "ev-socket-connected"), nil)
                    })
                })
            })
        case .charging:
            transitionDuration = 0.21
            self.animate(to: UIImage(named: "ev-socket-charging-1"), { _ in
                self.animate(to: UIImage(named: "ev-socket-charging-2"), { _ in
                    self.animate(to: UIImage(named: "ev-socket-charging-3"), { _ in
                        self.animate(to: UIImage(named: "ev-socket-charging"), nil)
                    })
                })
            })
        case .suspendedEV:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket-suspended"), nil)
        case .suspendedEVSE:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket-suspended"), nil)
        case .finishing:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket-preparing"), nil)
        case .reserved:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket-faulted"), nil)
        case .unavailable:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket"), nil)
        case .faulted:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket-faulted"), nil)
        case .unknown:
            transitionDuration = 0.55
            self.animate(to: UIImage(named: "ev-socket"), nil)
        }
    }
}
