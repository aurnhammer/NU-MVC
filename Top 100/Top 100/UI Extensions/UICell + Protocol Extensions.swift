//
//  UICell + Protocol Extensions.swift
//  Top 100
//
//  Created by William Aurnhammer on 1/30/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
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

/// Cell's that conform to the configurable protocol all a generic data handler to configure the cell with a generic Item.
public protocol Configurable {
    associatedtype Model
    func configure(withModel model: Model)
}

public protocol SectionModelConfigurable {
    func configure(withSectionModel model: SectionViewModelProtocol)
}

/// Conformance to Layoutable if required for Cells that wish to handle layout outside their class instance.
public protocol Layoutable {
    func layout()
}

public protocol Themeable {
    func theme()
}

