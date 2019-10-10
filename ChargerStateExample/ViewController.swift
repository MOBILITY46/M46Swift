//
//  ViewController.swift
//  ChargerStateExample
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit
import M46Swift

var connectors: [Int : ChargerOutlet.State] = [
    0: .available,
    1: .preparing,
    2: .charging,
    3: .suspendedEV,
    4: .faulted,
]

class Cell : UICollectionViewCell {
    lazy var outlet: ChargerOutlet = {
        let outlet = ChargerOutlet()
        outlet.size = 50
        addSubview(outlet.view)
        return outlet
    }()
}

extension UIViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return connectors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.outlet.state = connectors[indexPath.row]!
        return cell
    }
}

class ViewController: UIViewController {
    
    let chargeSwitch = ChargeSwitch()

    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.backgroundColor = .clear
        vc.dataSource = self
        vc.register(Cell.self, forCellWithReuseIdentifier: "cell")
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        chargeSwitch.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 3)
        
        collection.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        collection.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        chargeSwitch.addTarget(self, action: #selector(toggle), for: .valueChanged)
        
        view.addSubview(collection)
        view.addSubview(chargeSwitch)
        
    }
    
    @objc
    func toggle() {
        let random = Int.random(in: 0 ..< 5)
        if chargeSwitch.on {
            connectors.updateValue(.charging, forKey: random)
        } else {
            connectors.updateValue(.finishing, forKey: random)
        }
        collection.reloadData()
    }
}

