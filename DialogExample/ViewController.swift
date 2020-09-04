//
//  ViewController.swift
//  DialogExample
//
//  Created by David Jobe on 2020-09-04.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView(frame: .zero)
        v.backgroundColor = .red
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Close", for: .normal)
        v.addSubview(btn)
        
        let x = NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1, constant: 0)
        let y = NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: 0)
        
        v.addConstraints([x, y])
        
        let dialog = Dialog(parent: self, content: v, width: nil, height: nil)
        
        dialog.addCloseTarget(btn: btn)
        dialog.show(animated: true)
        // Do any additional setup after loading the view.
    }


}

