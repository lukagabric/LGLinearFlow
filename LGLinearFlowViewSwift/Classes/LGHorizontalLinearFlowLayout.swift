//
//  LGHorizontalLinearFlowLayout.swift
//  LGLinearFlowView
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

public class LGHorizontalLinearFlowLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = CGSizeZero
    
    public var scalingOffset: CGFloat = 200 //for offsets >= scalingOffset scale factor is minimumScaleFactor
    public var minimumScaleFactor: CGFloat = 0.7
    public var scaleItems: Bool = true

    
    static func configureLayout(collectionView collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> LGHorizontalLinearFlowLayout {
        let layout = LGHorizontalLinearFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.collectionViewLayout = layout
        
        return layout
    }

    override public func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayoutWithContext(context)

        if self.collectionView == nil {
            return
        }
        
        let currentCollectionViewSize = self.collectionView!.bounds.size
        
        if !CGSizeEqualToSize(currentCollectionViewSize, self.lastCollectionViewSize) {
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    private func configureInset() -> Void {
        if self.collectionView == nil {
            return
        }

        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        self.collectionView!.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        self.collectionView!.contentOffset = CGPointMake(-inset, 0)
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.collectionView == nil {
            return proposedContentOffset
        }
        
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionViewSize.width, collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElementsInRect(proposedRect)

        if layoutAttributes == nil {
            return proposedContentOffset
        }

        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2

        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .Cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPointMake(newOffsetX, proposedContentOffset.y)
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !self.scaleItems || self.collectionView == nil {
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let superAttributes = super.layoutAttributesForElementsInRect(rect)
        
        if superAttributes == nil {
            return nil
        }
        
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size

        let visibleRect = CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)
        let visibleCenterX = CGRectGetMidX(visibleRect)
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()

        for (_, attributes) in superAttributes!.enumerate() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        }
        
        return newAttributesArray;
    }
    
}
