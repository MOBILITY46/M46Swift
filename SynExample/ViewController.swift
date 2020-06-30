//
//  ViewController.swift
//  SynExample
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Syn { result in
            let lock: Bool = result.needsUpdate == true
            if result.hasUpdate {
                let (message, details) = result.info
                let dialog = Dialog(parent: self, title: message, text: details)
                dialog.dismissable = lock
                dialog.show(animated: true)
            }
        }.performCheck(<#T##currentVersion: <<error type>>##<<error type>>#>, bundleId: <#T##String#>)
    }

}

