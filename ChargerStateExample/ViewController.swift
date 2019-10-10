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
    
    let outlet = ChargerOutlet()
    let chargeSwitch = ChargeSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        outlet.size = 50
        
        outlet.imageView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        chargeSwitch.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 3)
        
        chargeSwitch.addTarget(self, action: #selector(toggle), for: .valueChanged)
        
        view.addSubview(outlet.imageView)
        view.addSubview(chargeSwitch)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        outlet.imageView.isUserInteractionEnabled = true
        outlet.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func toggle() {
        if chargeSwitch.on {
            outlet.set("Charging")
        } else {
            outlet.set("Preparing")
        }
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        switch outlet.state {
        case .available:
            outlet.set("Preparing")
            chargeSwitch.toggle(on: false)
        case .preparing:
            outlet.set("Charging")
            chargeSwitch.toggle(on: true)
        case .charging:
            outlet.set("Preparing")
            chargeSwitch.toggle(on: false)
        case .suspendedEV:
            outlet.set("Faulted")
            chargeSwitch.toggle(on: false)
        default:
            outlet.set("Available")
            chargeSwitch.toggle(on: false)
        }
    }


}

