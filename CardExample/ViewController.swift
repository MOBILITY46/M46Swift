//
//  ViewController.swift
//  Example
//
//  Created by David Jobe on 2019-03-28.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit
import M46Swift

class ViewController: UIViewController {

    lazy var front: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()

    lazy var back: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    lazy var card: Card = {
        let c = Card(front: front, back: back)
        return c
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let c1 = NSLayoutConstraint(
                item: card,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide,
                attribute: .leading,
                multiplier: 1,
                constant: 15
            )
        let c2 = NSLayoutConstraint(
                item: card,
                attribute: .top,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide,
                attribute: .top,
                multiplier: 1,
                constant: 30
            )
        let c3 = NSLayoutConstraint(
            item: card,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view.safeAreaLayoutGuide,
            attribute: .trailing,
            multiplier: 1,
            constant: -15
        )
        let c4 = NSLayoutConstraint(
            item: card,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view.safeAreaLayoutGuide,
            attribute: .bottom,
            multiplier: 1,
            constant: -30
        )
        NSLayoutConstraint.activate([c1, c2, c3, c4])

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        card.flip()
    }

}
