//
//  TicketStackLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 7/19/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol  PassbookLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:NSIndexPath) -> CGFloat
    func widthOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func xOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat
    func getSelectedCellCollectionView(collectionView: UICollectionView) -> Int
    func getScrollOffset(collectionView: UICollectionView) -> CGPoint
}

class TicketStackLayout: UICollectionViewLayout {
    
    var delegate: PassbookLayoutDelegate!
    
    var cellPadding : CGFloat = 57.1
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight : CGFloat = 0.0
    private var contentWidth : CGFloat = 0.0

    
    override func prepareLayout() {
        if cache.isEmpty {
            
            let xOffset = delegate.xOffsetOfTicketsOfCollectionView(collectionView!)
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let ticketHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                let ticketWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                let frame = CGRect(x: xOffset, y:CGFloat(item)*cellPadding, width: ticketWidth, height: ticketHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                if item == collectionView!.numberOfItemsInSection(0) - 1 {
                    contentHeight += ticketHeight
                }
                else {
                    contentHeight += cellPadding
                }
            }
            contentWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
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
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        return delegate.getScrollOffset(collectionView!)
    }

}
