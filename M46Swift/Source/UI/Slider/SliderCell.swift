//
//  SliderCell.swift
//  M46SwiftySlider
//
//  Created by David Jobe on 2019-05-20.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

 /*
    Collection view cells used with SliderView should subclass this type
 */
open class SliderCell: UICollectionViewCell {
    
    open var scaleMinimum: CGFloat = 0.9
    private var divisor: CGFloat = 8.0
    open var alphaMinimum: CGFloat = 0.45
    
    open var content: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        content = UIView(frame: contentView.bounds)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        animate()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        content.transform = CGAffineTransform.identity
        content.alpha = 1.0
    }
    
    open func animate() {
        guard let superview = superview,
            let content = content else { return }
        
        let x = superview.convert(frame, to: superview.superview).origin.x
        let width = frame.size.width
        
        let c = abs(width - abs(x))
        let p = c / width
        
        let alphaValue = alphaMinimum
            + (p / divisor)

        content.alpha = alphaValue
    }
}
