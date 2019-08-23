//
//  SliderLayout.swift
//  M46SwiftySlider
//
//  Created by David Jobe on 2019-05-20.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

/*
 SliderLayout is used together with SPBCarouselView to
 provide a carousel-style collection view.
 */
open class SliderLayout: UICollectionViewFlowLayout {
    
    open var inset: CGFloat = 10
    
    override open func prepare() {
        
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        itemSize = collectionViewSize
        itemSize.width = itemSize.width - (inset * 2)
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        footerReferenceSize = CGSize.zero
        headerReferenceSize = CGSize.zero
    }
}
