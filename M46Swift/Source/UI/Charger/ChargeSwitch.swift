//
//  ChargerSwitch.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-07.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

public class ChargeSwitch: UIControl {
    var on: Bool = false

    public var padding: CGFloat = 1 {
        didSet {
            layoutSubviews()
        }
    }

    public var onTintColor: UIColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1) {
        didSet {
            setupUI()
        }
    }
    
    public var offTintColor: UIColor = UIColor.lightGray {
        didSet {
            setupUI()
        }
    }
    
    public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            thumbView.backgroundColor = thumbTintColor
        }
    }

    var cornerRadius: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }

    var thumbView = UIView(frame: CGRect.zero)
    var onPoint = CGPoint.zero
    var offPoint = CGPoint.zero

    var isAnimating = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        initializeSubviews()

    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
    public func toggle(on: Bool) {
        thumbView.frame.origin.x = on ? onPoint.x : offPoint.x
        backgroundColor = on ? onTintColor : offTintColor
        self.on = on
        layoutSubviews()
    }

}

typealias ChargeSwitchRenderer = ChargeSwitch

extension ChargeSwitchRenderer {
    
    fileprivate func initializeSubviews() {
        if !isAnimating {
            layer.cornerRadius = bounds.size.height * cornerRadius
            backgroundColor = on ? onTintColor : offTintColor
            
            let thumbSize =  CGSize(
                width: bounds.size.height - 2,
                height: bounds.height - 2
            )
            
            let yPostition = (bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPostition)
            self.offPoint = CGPoint(x: padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: on ? onPoint : offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * thumbCornerRadius
        }
    }
    
    func setupUI() {
        clear()
        frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        clipsToBounds = false
        thumbView.backgroundColor = thumbTintColor
        thumbView.isUserInteractionEnabled = false
        addSubview(thumbView)
        
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowRadius = 1.5
        thumbView.layer.shadowOpacity = 0.4
        thumbView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
    }
    
    fileprivate func clear() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

typealias ChargeSwitchAnimation = ChargeSwitch

extension ChargeSwitchAnimation {
    
    fileprivate func animate() {
        on = !on
        isAnimating = true
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut, .beginFromCurrentState],
            animations: {
                self.thumbView.frame.origin.x = self.on ? self.onPoint.x : self.offPoint.x
                self.backgroundColor = self.on ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: .valueChanged)
        })
    }
}
