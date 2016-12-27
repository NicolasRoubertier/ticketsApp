//
//  EventsCollectionViewLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/9/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol  EventsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:IndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func xOffsetOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func yOffsetOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
}

class EventsCollectionViewLayout: UICollectionViewLayout {
    
    var delegate : EventsLayoutDelegate!
    
    var cellPadding : CGFloat = 50.0
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight : CGFloat = 0.0
    fileprivate var contentWidth : CGFloat = 0.0
    
    override func prepare() {
        if cache.isEmpty {
            let xOffset = delegate.xOffsetOfTicketsOfCollectionView(collectionView!)
            let yOffset = delegate.yOffsetOfTicketsOfCollectionView(collectionView!)
            contentHeight += yOffset
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let eventHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                let eventWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                let frame = CGRect(x: xOffset, y:CGFloat(yOffset + (eventHeight+cellPadding)*CGFloat(item)), width: eventWidth, height: eventHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                if item == collectionView!.numberOfItems(inSection: 0) - 1 {
                    contentHeight += eventHeight
                }
                else {
                    contentHeight += eventHeight + cellPadding
                }
            }
            contentWidth += delegate.widthOfTicketsOfCollectionView(collectionView!)
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
            else {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
