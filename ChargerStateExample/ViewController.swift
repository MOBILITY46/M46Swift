//
//  ViewController.swift
//  ChargerStateExample
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit
import M46Swift

class ViewController: UIViewController {
    
    let chargerState = ChargerState()
    let chargeSwitch = ChargeSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        chargerState.size = 50
        
        chargerState.imageView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        chargeSwitch.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 3)
        
        chargeSwitch.addTarget(self, action: #selector(toggle), for: .valueChanged)
        
        view.addSubview(chargerState.imageView)
        view.addSubview(chargeSwitch)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        chargerState.imageView.isUserInteractionEnabled = true
        chargerState.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func toggle() {
        if chargeSwitch.on {
            chargerState.set("Charging")
        } else {
            chargerState.set("Preparing")
        }
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        switch chargerState.state {
        case .available:
            chargerState.set("Preparing")
            chargeSwitch.toggle(on: false)
        case .preparing:
            chargerState.set("Charging")
            chargeSwitch.toggle(on: true)
        case .charging:
            chargerState.set("Preparing")
            chargeSwitch.toggle(on: false)
        case .suspendedEV:
            chargerState.set("Faulted")
            chargeSwitch.toggle(on: false)
        default:
            chargerState.set("Available")
            chargeSwitch.toggle(on: false)
        }
    }


}

