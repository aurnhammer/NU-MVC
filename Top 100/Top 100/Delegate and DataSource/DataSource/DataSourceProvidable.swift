//
//  DataSourceProvidable.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

/// An object that adopts the DataSourceProvidable protocol is responsible for vending information to an items view as needed. It also handles the creation and configuration of cells used by the item view to display data.
public protocol DataSourceProvidable {
    
    /// A generic representation of the type to be displayed.
    associatedtype Item
    
    /// Asks the data handler object for the number of sections in the item view.
    
    /// Implemented in the DataHandlerAbstractClass.
    ///- Returns: Int
    func numberOfSections() -> Int
    
    /// Asks the data handler object for the number of items in a section of an item view.
    ///
    /// Implemented in the DataHandlerAbstractClass.
    ///
    /// - Parameters:
    ///    - section: An Int identifying a section in item view. This index value is 0-based.
    /// - Returns: Int
    func numberOfItems(in section: Int) -> Int
    
    /// Asks your data handler object for the cell that corresponds to the specified item in the item view.
    /// Implemented in the Data Provider Abstract Class.
    /// - Parameters:
    ///   - sequenceView: The item view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item
    /// - Returns: A cell conforming to the reusable cell protocol
    func sequenceView<Cell>(_ sequenceView: CellDequeable, cellForItemAt indexPath: IndexPath) -> Cell where Cell: Reusable, Cell: Configurable, Item == Cell.Item
}
