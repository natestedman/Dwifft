//
//  CollectionViewDiffCalculator.swift
//  Dwifft
//
//  Created by Nate Stedman on 9/19/15.
//  Copyright © 2015 jflinter. All rights reserved.
//

import UIKit

public class CollectionViewDiffCalculator<T: Equatable> {
    
    public weak var collectionView: UICollectionView?
    
    public init(collectionView: UICollectionView, initialItems: [T] = []) {
        self.collectionView = collectionView
        self.items = initialItems
    }
    
    /// Right now this only works on a single section of a collection view. If your collection view has multiple sections, though, you can just use multiple CollectionViewDiffCalculators, one per section, and set this value appropriately on each one.
    public var sectionIndex: Int = 0
    
    /// Change this value to trigger animations on the collection view.
    public var items : [T] {
        didSet {
            let oldItems = oldValue
            let newItems = self.items
            let changes = oldItems.diff(newItems)
            
            if (changes.count > 0) {
                let insertionIndexPaths = changes.filter({ $0.isInsertion }).map({ NSIndexPath(forItem: $0.idx, inSection: self.sectionIndex) })
                let deletionIndexPaths = changes.filter({ !$0.isInsertion }).map({ NSIndexPath(forItem: $0.idx, inSection: self.sectionIndex) })
                
                collectionView?.performBatchUpdates({
                    self.collectionView?.insertItemsAtIndexPaths(insertionIndexPaths)
                    self.collectionView?.deleteItemsAtIndexPaths(deletionIndexPaths)
                }, completion: nil)
            }
        }
    }
}
