//
//  UICell + Protocol Extensions.swift
//  Top 100
//
//  Created by William Aurnhammer on 1/30/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit
import CoreData

/// Cell that conform to Reusable use the Cell's class name as its identifier
public protocol Reusable {
    static var reuseIdentifier: String { get }
}

/// Conformance to the reusable protocol using the Cell's class name
extension Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// Collection view Cell conformance to the reusable protocol
extension UICollectionViewCell: Reusable {}

/// Table view Cell conformance to the reusable protocol
extension UITableViewCell: Reusable {}

/// Cell's that conform to the configurable protocol all a generic data handler to configure the cell with a generic Item.
public protocol Configurable {
    associatedtype Item
    func configure(with item: Item)
}

/// Conformance to Layoutable if required for Cells that wish to handle layout outside their class instance.
public protocol Layoutable {
    func layout()
}
