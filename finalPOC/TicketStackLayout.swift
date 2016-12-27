//
//  TicketStackLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 7/19/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol  PassbookLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:IndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func xOffsetOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func getSelectedCellCollectionView(_ collectionView: UICollectionView) -> Int
    func getScrollOffset(_ collectionView: UICollectionView) -> CGPoint
}

class TicketStackLayout: UICollectionViewLayout {
    
    var delegate: PassbookLayoutDelegate!
    
    var cellPadding : CGFloat = 57.1
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight : CGFloat = 0.0
    fileprivate var contentWidth : CGFloat = 0.0

    
    override func prepare() {
        if cache.isEmpty {
            
            let xOffset = delegate.xOffsetOfTicketsOfCollectionView(collectionView!)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let ticketHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                let ticketWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                let frame = CGRect(x: xOffset, y:CGFloat(item)*cellPadding, width: ticketWidth, height: ticketHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                if item == collectionView!.numberOfItems(inSection: 0) - 1 {
                    contentHeight += ticketHeight
                }
                else {
                    contentHeight += cellPadding
                }
            }
            contentWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
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
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return delegate.getScrollOffset(collectionView!)
    }

}
