//
//  UICollectionView + Extensions.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/3/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import CoreData
import UIKit

/// An object that conforms to CellDequeable is capable of dequeing a reusable cell whose cell identifier is its class name
public protocol CellDequeable {
    func dequeueReusableCell<Cell: Reusable>(forIndexPath indexPath: IndexPath) -> Cell
}

/// Protocol conformance to enable a Collection View to dequeue a reusable cell based on its class name
extension UICollectionView: CellDequeable {
    public func dequeueReusableCell<Cell>(forIndexPath indexPath: IndexPath) -> Cell where Cell : Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
    
 }

public protocol CollectionViewCell {
    var bounds: CGRect { get }
    var frame: CGRect { get }
    var layer: CALayer { get }
    var isSelected: Bool { get set }
    
   init(frame: CGRect)
}

extension UICollectionViewCell: CollectionViewCell {}

/// Conformance to ItemsView bridges datasource methods between a UICollectionView and a UITableView
public protocol CollectionView {
    func collectionViewCell(at indexPath: IndexPath) -> CollectionViewCell?
}

//
extension UICollectionView: CollectionView {
    public func collectionViewCell(at indexPath: IndexPath) -> CollectionViewCell? {
        return cellForItem(at:indexPath)
    }
//
}
