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
        
        outlet.view.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        chargeSwitch.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 3)
        
        chargeSwitch.addTarget(self, action: #selector(toggle), for: .valueChanged)
        
        view.addSubview(outlet.view)
        view.addSubview(chargeSwitch)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        outlet.view.isUserInteractionEnabled = true
        outlet.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func toggle() {
        if chargeSwitch.on {
            outlet.state = .preparing
        } else {
            outlet.state = .available
        }
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        /*
        switch outlet.state {
        case .available:
            outlet.state = .preparing
            chargeSwitch.toggle(on: false)
        case .preparing:
            outlet.state = .charging
            chargeSwitch.toggle(on: true)
        case .charging:
            outlet.state = .preparing
            chargeSwitch.toggle(on: false)
        default:
            outlet.state = .available
            chargeSwitch.toggle(on: false)
        }
        */
        chargeSwitch.disabled = !chargeSwitch.disabled
    }


}

