//
//  LockedTicketsCollectionViewLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/10/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol LockedTicketsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:NSIndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func yOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func shouldDisplayCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> Bool
    func getCurrentEvent(collectionView: UICollectionView) -> Int
}

class LockedTicketsCollectionViewLayout: UICollectionViewLayout {
    
    var delegate : LockedTicketsLayoutDelegate!
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight : CGFloat = 0.0
    private var contentWidth : CGFloat = 0.0
    var isBeingReloaded : Bool = false
    
    override func prepareLayout() {
        if cache.isEmpty || isBeingReloaded{
            if(isBeingReloaded) {
                contentHeight = 0.0
                contentWidth = 0.0
                cache.removeAll()
                isBeingReloaded = false
            }
            let yOffset = delegate.yOffsetOfTicketsOfCollectionView(collectionView!)
            contentHeight += yOffset
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath : NSIndexPath =  NSIndexPath(forItem: item, inSection: 0)
                    if delegate.shouldDisplayCell(collectionView!, indexPath: indexPath) {
                        let ticketHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                        let ticketWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                        let frame = CGRect(x: 0, y:contentHeight, width: ticketWidth, height: ticketHeight)
                        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        attributes.frame = frame
                        cache.append(attributes)
                        contentHeight += ticketHeight
                        contentWidth = ticketWidth
                    }
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
            else {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
