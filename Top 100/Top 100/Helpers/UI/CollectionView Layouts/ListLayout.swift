//
//  ListLayout.swift
//
//  Created by William Aurnhammer on 1/5/17.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit

final public class ListLayout: UICollectionViewFlowLayout {
    
    private let spacing: CGFloat = 8.0
    private let cellHeight = CGFloat(200.0)

    override public func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            fatalError("ListLayout requires a CollectionView")
        }
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        let cellWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        sectionInset = UIEdgeInsets(top: collectionView.layoutMargins.top,
                                    left: collectionView.layoutMargins.left + (spacing/2.0),
                                    bottom: collectionView.layoutMargins.bottom,
                                    right: collectionView.layoutMargins.right + (spacing/2.0))
        sectionInsetReference = .fromSafeArea
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return CGPoint()}
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

}
