//
//  TicketStackCollapsedLayout.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 7/20/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

class TicketStackCollapsedLayout: UICollectionViewLayout {
    
    var delegate : PassbookLayoutDelegate!
    var collapsedCellPadding : CGFloat = 15.0
    var gapPadding : CGFloat = 30.0
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight : CGFloat = 0.0
    fileprivate var contentWidth : CGFloat = 0.0
    
    override func prepare() {
        
        
        if cache.isEmpty {
            
            let xOffset = delegate.xOffsetOfTicketsOfCollectionView(collectionView!)
            var numberOfCollapsedCells : Int = 0
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                    let indexPath = IndexPath(item: item, section: 0)
                    let ticketHeight = delegate.collectionView(collectionView!, heightOfCellAtIndexPath: indexPath)
                    let ticketWidth = delegate.widthOfTicketsOfCollectionView(collectionView!)
                    
                    if item == delegate.getSelectedCellCollectionView(collectionView!) {
                        let frame = CGRect(x: xOffset, y: 0, width: ticketWidth, height: ticketHeight)
                        contentHeight += ticketHeight + gapPadding
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = frame
                        cache.append(attributes)
                    }
                    else {
                        let frame = CGRect(x: xOffset, y: CGFloat(ticketHeight+gapPadding+(CGFloat(numberOfCollapsedCells)*collapsedCellPadding)), width: ticketWidth, height: ticketHeight)
                        numberOfCollapsedCells += 1
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = frame
                        cache.append(attributes)
                        if numberOfCollapsedCells == collectionView!.numberOfItems(inSection: 0) - 2 {
                            contentHeight += ticketHeight
                        }
                        else {
                            contentHeight += collapsedCellPadding
                        }
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
