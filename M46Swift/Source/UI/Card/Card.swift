//
//  Card.swift
//
//  Created by David Jobe on 2019-03-28.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

public protocol CardDelegate {
    func cardFlipped(_ current: UIView)
}

public class Card : UIView {
    
    public var front: UIView
    public var back: UIView?
    public var delegate: CardDelegate?
    
    // MARK: Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        self.front = UIView()
        super.init(coder: aDecoder)
        initialize()
    }
    
    public init(front: UIView, back: UIView?) {
        self.front = front
        self.back = back
        super.init(frame: .zero)
        initialize()
    }
    
    // MARK: Configuration
    
    fileprivate var current: UIView {
        if front.superview != nil {
            return front
        } else {
            return back!
        }
    }
    
    public var borderColor: UIColor = .lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public var cornerRadius: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cornerRadius
            front.layer.cornerRadius = cornerRadius
            if let back = back {
                back.layer.cornerRadius = cornerRadius
            }
        }
    }

    private func initialize() {
        borderColor = .lightGray
        cornerRadius = 20
        
        addSubview(front)
    }
    
    override open func layoutSubviews() {
        if front.superview != nil {
            configure(view: front)
        }
        if let back = back {
            if back.superview != nil {
                configure(view: back)
            }
        }
    }
}

typealias PublicAPI = Card
extension PublicAPI {
    
    public func flip() {
        if back == nil { return }
        
        let flipped = self.front.superview == nil

        var opts: AnimationOptions = []
        
        if flipped {
            opts.insert(AnimationOptions.transitionFlipFromRight)
        } else {
            opts.insert(AnimationOptions.transitionFlipFromLeft)
        }
        
        UIView.transition(with: self, duration: 0.5, options: opts, animations: {
            
            if flipped {
                self.back!.removeFromSuperview()
                self.addSubview(self.front)
            } else {
                self.front.removeFromSuperview()
                self.addSubview(self.back!)
            }
            
        }, completion: { finished in
            self.delegate?.cardFlipped(self.current)
        })
    }
    
}

extension Card {
    
    fileprivate func configure(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let c1 = NSLayoutConstraint(
            item: view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        let c2 = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        let c3 = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        let c4 = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        NSLayoutConstraint.activate([c1, c2, c3, c4])
    }
}
