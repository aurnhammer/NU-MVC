//
//  Datasource.swift
//  Top 100
//
//  Created by William Aurnhammer on 1/31/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

/// Storage for our Object that confroms to DataProvidable
open class DataSource<Provider: DataSourceProvidable>: NSObject {
    
    // MARK: - Private Properties
    public let dataProvider: Provider
    
    // MARK: - Initialzier
    public init(with dataProvider: Provider) {
        self.dataProvider = dataProvider
        super.init()
    }
}

/// Conform the DataSource to the NSFetchedResultsControllerDelegate
open class FetchedResultsControllerDelegate<Provider: FetchedDataSourceProvidable>: DataSource<Provider>, NSFetchedResultsControllerDelegate {
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataProvider.willChangeContent()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        dataProvider.didChange(atSectionIndex: sectionIndex, forType: type)
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        dataProvider.didChange(atIndexPath: indexPath, forType: type, newIndexPath: newIndexPath)
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataProvider.didChangeContent()
    }
}

final class ViewDataSource<Provider: FetchedDataSourceProvidable>:  FetchedResultsControllerDelegate<Provider> {
    
    
}

/// A CollectionViewDataSource
final class CollectionViewDataSource<Provider: FetchedDataSourceProvidable, Cell: UICollectionViewCell>:  FetchedResultsControllerDelegate<Provider>, UICollectionViewDataSource where Provider.Item == Cell.Item, Cell: Configurable {
    
    // MARK: - Instance Functions
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(in: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let cell = dataProvider.sequenceView(collectionView, cellForItemAt: indexPath) as Cell
        return cell
    }
}

/// A TableViewDataSource is a concrete subclass of DataSource that represents the data model object. As such, it supplies no information about appearance (including the cells).
/// Additionaly it conforms to the FetchedResultsControllerDelegate protocol
final class TableViewDataSource<Provider: FetchedDataSourceProvidable, Cell: UITableViewCell>: FetchedResultsControllerDelegate<Provider>, UITableViewDataSource where Provider.Item == Cell.Item, Cell: Configurable {

    // MARK: - Instance Functions
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }

     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(in: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataProvider.sequenceView(tableView, cellForItemAt: indexPath) as Cell
        return cell
    }
}
