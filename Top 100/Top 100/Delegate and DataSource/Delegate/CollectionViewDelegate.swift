//
//  CollectionViewDelegate.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

/// A CollectionViewDelegate is a concrete subclass of UICollectionViewDelegate that vends the UICollectionViewDelegate's responsibilites to an object the conforms to DelegateProvidable.
final class CollectionViewDelegate<Provider: DelegateProvidable>: Delegate<Provider>, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateProvider.selectionProvider?.didSelect(itemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegateProvider.selectionProvider?.didDeselect(itemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        delegateProvider.highlightProvider?.didHighlight(itemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        delegateProvider.highlightProvider?.didUnhighlight(itemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateProvider.cellProvider?.willDisplay(cell: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateProvider.cellProvider?.didEndDisplaying(cell: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        delegateProvider.suplimentaryViewProvider?.willDisplay(supplementaryView: view, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        delegateProvider.suplimentaryViewProvider?.didEndDisplaying(supplementaryView: view, forItemAt: indexPath)
    }
    
}
