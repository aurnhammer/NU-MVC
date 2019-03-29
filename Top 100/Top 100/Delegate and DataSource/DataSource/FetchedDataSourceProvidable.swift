//
//  FetchedDataSourceProvidable.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

/// An object that adopts the FetchedDataProvidable protocol is responsible for vending information to an item view as needed. It also handles the creation and configuration of cells used by the SequenceView to display data via its superclass DataSourceProvidable.
public protocol FetchedDataSourceProvidable: DataSourceProvidable {
    
    // MARK: - Public Properties
    
    associatedtype ViewController
    
    /// An object that confoms to the FetchedCollectionViewProtocol used to inform the ItemsView on updates to the Datasource
    var viewController: ViewController! { get set }
    
    /// Tell the fetchedViewController content will change.
    func willChangeContent()
    
    /// Tell the fetchedViewController content did change in Section.
    func didChange(atSectionIndex sectionIndex: Int, forType type: NSFetchedResultsChangeType)
    
    /// Tell the fetchedViewController content did change at IndexPath.
    func didChange(atIndexPath indexPath: IndexPath?, forType type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    
    /// Tell the fetchedViewController content has changed.
    func didChangeContent()
    
}
