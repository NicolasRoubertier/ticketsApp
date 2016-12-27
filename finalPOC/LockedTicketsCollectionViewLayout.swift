//
//  LockedTicketsCollectionViewLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/10/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol LockedTicketsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:IndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func yOffsetOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func shouldDisplayCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> Bool
    func getCurrentEvent(_ collectionView: UICollectionView) -> Int
}

class LockedTicketsCollectionViewLayout: UICollectionViewLayout {
    
    var delegate : LockedTicketsLayoutDelegate!
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight : CGFloat = 0.0
    fileprivate var contentWidth : CGFloat = 0.0
    var isBeingReloaded : Bool = false
    
    override func prepare() {
        if cache.isEmpty || isBeingReloaded{
            if(isBeingReloaded) {
                contentHeight = 0.0
                contentWidth = 0.0
                cache.removeAll()
                isBeingReloaded = false
            }
            let yOffset = delegate.yOffsetOfTicketsOfCollectionView(collectionView!)
            contentHeight += yOffset
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath : IndexPath =  IndexPath(item: item, section: 0)
                    if delegate.shouldDisplayCell(collectionView!, indexPath: indexPath) {
                        let ticketHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                        let ticketWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                        let frame = CGRect(x: 0, y:contentHeight, width: ticketWidth, height: ticketHeight)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = frame
                        cache.append(attributes)
                        contentHeight += ticketHeight
                        contentWidth = ticketWidth
                    }
            }
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
