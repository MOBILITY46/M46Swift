//
//  Toast.swift
//  M46SwiftyToast
//
//  Created by David Jobe on 2019-03-26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public enum ToastType {
    case success
    case error
    case warning
}

public protocol ToastDelegate : class {
    func onTouchUpInside(toast: Toast)
}

public class Toast : UIView {
    public var message: String
    public var type: ToastType?
    public var delegate: ToastDelegate?
    public var duration: Double = 3.0
    
    fileprivate var heightConstraint: NSLayoutConstraint?
    fileprivate var centerXConstraint: NSLayoutConstraint?
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var widthConstraint: NSLayoutConstraint?
    
    private var color: UIColor {
        guard let type = type else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
        switch type {
        case .error:
            return UIColor(red: 183/255, green: 28/255, blue: 28/255, alpha: 0.8)
        case .success:
            return UIColor(red: 75/255, green: 175/255, blue: 80/255, alpha: 0.8)
        case .warning:
            return UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 0.8)
        }
    }
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = message
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var bgLayer: CALayer = {
        let bg = CALayer()
        bg.backgroundColor = UIColor.black.cgColor
        bg.cornerRadius = 20.0
        bg.backgroundColor = color.cgColor
        return bg
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        self.message = ""
        super.init(coder: aDecoder)
    }
    
    public init(message: String, type: ToastType? = nil) {
        self.message = message
        self.type = type
        super.init(frame: .zero)
        initialize()
    }
    
    private func initialize() {
        alpha = 0
        layer.addSublayer(bgLayer)
        addSubview(label)
        configureLabelConstraints()
        
        if isUserInteractionEnabled {
           addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpInside)))
        }
    }
    
    @objc func touchUpInside() {
        delegate?.onTouchUpInside(toast: self)
    }
    
    public func show() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return
            }
            self.configureConstraints(keyWindow)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                self.alpha = 0.8
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: self.duration, options: .curveEaseOut, animations: {
                    self.alpha = 0.0
                }, completion: {_ in
                    keyWindow.removeFromSuperview()
                })
            })
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        bgLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}

extension Toast {
    
    fileprivate func configureConstraints(_ window: UIView) {
        window.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 40
        )
        centerXConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: window,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        topConstraint = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: window,
            attribute: .top,
            multiplier: 1,
            constant: window.bounds.height / 3 * 2
        )
        widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .greaterThanOrEqual,
            toItem: window,
            attribute: .width,
            multiplier: 0.7,
            constant: 0
        )
        
        window.addConstraints([topConstraint!, centerXConstraint!, heightConstraint!, widthConstraint!])
    }
    
    fileprivate func configureLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXConstraint = NSLayoutConstraint(
            item: label,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        let centerYConstraint = NSLayoutConstraint(
            item: label,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        self.addConstraints([centerXConstraint, centerYConstraint])
    }
}
