//
//  SliderView.swift
//  M46SwiftySlider
//
//  Created by David Jobe on 2019-05-20.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

open class SliderView: UICollectionView {
    
    private var lastCurrentCenterCellIndex: IndexPath?
    
    /// Returns the current center cell of the slider if it can be calculated
    open var currentCenterCell: UICollectionViewCell? {
        let lowerBound: CGFloat = -10.0
        let upperBound: CGFloat = 30.0
        
        for cell in visibleCells {
            
            let cellRect = convert(cell.frame, to: nil)
            
            if cellRect.origin.x > lowerBound && cellRect.origin.x < upperBound {
                return cell
            }
            
        }
        
        return nil
    }
    
    /// Inset of the main, center cell
    public var inset: CGFloat = 10.0 {
        didSet {
            configureLayout()
        }
    }
    
    /// Returns the IndexPath of the current center cell if it can be calculated
    open var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else { return nil }
        
        return indexPath(for: currentCenterCell)
    }
    
    /// Override of the collection view content size to add an observer
    override open var contentSize: CGSize {
        didSet {
            
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            
            // Calculate total number of items in collection view
            var numberItems = 0
            
            for i in 0..<numberSections {
                
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            
            // Set the invisibleScrollView contentSize width based on number of items
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    fileprivate var invisibleScrollView: UIScrollView!
    fileprivate var invisibleWidthConstraint: NSLayoutConstraint?
    fileprivate var invisibleLeftConstraint: NSLayoutConstraint?
    

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: SliderLayout())
    }
    
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override open func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: animated)
        lastCurrentCenterCellIndex = indexPath
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addInvisibleScrollView(to: superview)
    }
    
    public func didScroll() {
        scrollViewDidScroll(self)
    }
}

private typealias PrivateAPI = SliderView
fileprivate extension PrivateAPI {
    
    func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else { return }
        
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        
        invisibleScrollView.isUserInteractionEnabled = false
        invisibleScrollView.delegate = self
        
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        superview.addSubview(invisibleScrollView)
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        configureLayout()
    }
    
    func configureLayout() {
        
        collectionViewLayout = SliderLayout()
        clipsToBounds = false
        
        guard let invisibleScrollView = invisibleScrollView else { return }
        
        invisibleWidthConstraint?.isActive = false
        invisibleLeftConstraint?.isActive = false
        
        invisibleWidthConstraint = invisibleScrollView.widthAnchor.constraint(
            equalTo: widthAnchor, constant: -(2 * inset))
        invisibleLeftConstraint =  invisibleScrollView.leftAnchor.constraint(
            equalTo: leftAnchor, constant: inset)
        
        invisibleWidthConstraint?.isActive = true
        invisibleLeftConstraint?.isActive = true
    }
}

private typealias InvisibleScrollDelegate = SliderView
extension InvisibleScrollDelegate: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateOffSet()
        for cell in visibleCells {
            if let c = cell as? SliderCell {
                c.animate()
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        guard let indexPath = currentCenterCellIndex else { return }
        lastCurrentCenterCellIndex = indexPath
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}

