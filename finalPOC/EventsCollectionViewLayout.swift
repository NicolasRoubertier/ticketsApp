//
//  EventsCollectionViewLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/9/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol  EventsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:NSIndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func xOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func yOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
}

class EventsCollectionViewLayout: UICollectionViewLayout {
    
    var delegate : EventsLayoutDelegate!
    
    var cellPadding : CGFloat = 50.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight : CGFloat = 0.0
    private var contentWidth : CGFloat = 0.0
    
    override func prepareLayout() {
        if cache.isEmpty {
            let xOffset = delegate.xOffsetOfTicketsOfCollectionView(collectionView!)
            let yOffset = delegate.yOffsetOfTicketsOfCollectionView(collectionView!)
            contentHeight += yOffset
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let eventHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                let eventWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                let frame = CGRect(x: xOffset, y:CGFloat(yOffset + (eventHeight+cellPadding)*CGFloat(item)), width: eventWidth, height: eventHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                if item == collectionView!.numberOfItemsInSection(0) - 1 {
                    contentHeight += eventHeight
                }
                else {
                    contentHeight += eventHeight + cellPadding
                }
            }
            contentWidth += delegate.widthOfTicketsOfCollectionView(collectionView!)
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
