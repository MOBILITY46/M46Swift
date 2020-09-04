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
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "THIS IS CONTENT!"
        lbl.font = .boldSystemFont(ofSize: 30)
        lbl.textColor = .black
        v.addSubview(lbl)
        
        let x = NSLayoutConstraint(item: lbl, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1, constant: 0)
        let y = NSLayoutConstraint(item: lbl, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: 0)
        
        v.addConstraints([x, y])
        
        let dialog = Dialog(parent: self, content: v, width: nil, height: nil)
        dialog.show(animated: true)
        // Do any additional setup after loading the view.
    }


}

