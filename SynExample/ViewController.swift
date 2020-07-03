//
//  ViewController.swift
//  SynExample
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    func goToAppStore() {
        guard let url = URL(string: "itms-apps://apps.apple.com/us/app/id1373619671") else { return }
        UIApplication.shared.open(url)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let current = try? SemVer.parse(text) else {
            Log.error("Could not determine app version.")
            return
        }

        SynClient { result in
            switch result {
                case .success(let data):
                    Log.debug("data: \(data)")
                    
                    let footer = UILabel()
                    footer.text = "Current version: \(current)"
                    let dialog = Dialog(parent: self, title: "Please update!", text: "There is a new version that lets you flip hamters in obvious ways. The current version does not support them dying.", footer: footer)
                    dialog.closeAction = self.goToAppStore
                    dialog.show(animated: true)

                case .failure(let err):
                    Log.error("ERROR: \(err)")
            }
            /*
            if result. {
                let (message, details) = result.info
                let dialog = Dialog(parent: self, title: message, text: details)
                dialog.dismissable = lock
                dialog.show(animated: true)
            }
            */
        }.performCheck()
    }

}

