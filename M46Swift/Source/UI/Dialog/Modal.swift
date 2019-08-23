//
//  Modal.swift
//  M46SwiftyDialog
//
//  Created by David Jobe on 2019-05-17.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

protocol Modal {
    var backgroundView: UIView { get }
    var dialogView: UIView { get set }
    func show(animated: Bool)
    func dismiss(animated: Bool)
}

extension Modal where Self: UIView {
    
    func show(animated: Bool) {
        
        backgroundView.alpha = 0
        dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        
        if animated {
            
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                self.dialogView.center  = self.center
            }, completion: { (completed) in
                
            })
            
        } else {
            
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
            
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }
    
}
