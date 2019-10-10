//
//  StateMachine.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

enum State {}

protocol StateMachineState {
    associatedtype T = State
    var state: T { get set }
    mutating func stateChanged(_ callback: @escaping (_ sm: StateMachine<T>) -> Void) -> Void
}

public class StateMachine<T> : StateMachineState {
    
    var callback: ((_ sm: StateMachine<T>) -> Void)?
    
    public var state: T {
        didSet {
            if let callback = callback {
                callback(self)
            }
        }
    }
    
    public init(state: T) {
        self.state = state
    }
    
    public func stateChanged(_ callback: @escaping (_ sm: StateMachine<T>) -> Void) {
        self.callback = callback
    }
    
}
