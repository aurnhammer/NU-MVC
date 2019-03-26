//
//  FetchedDataSourceProvider.swift
//  Top 100
//
//  Created by William Aurnhammer on 1/31/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

/// Class to handle asynchronous updates to an SequenceViewer
final class FetchedDataSourceProvider<Item>: FetchedDataSourceProvidable {
    
    public typealias ViewController = SequenceFetching
    public var viewController: ViewController!
    
    // MARK: - Private Properties
    private var animatedUpdates = true
    private var rowDictionary: [NSFetchedResultsChangeType : [IndexPath]]!
    private var sectionDictionary: [NSFetchedResultsChangeType : [Int]]!
    
    // MARK: - Initializer
    
    /// Initialzer for the Albums Datasource.
    ///
    /// - Parameters:
    ///    - fetchedController: Injects the dependency on the FetchedCollectionViewController into the Datasource class.
    public init<ViewController: SequenceFetching>(withFetchableViewController fetchableViewController: ViewController) {
        viewController = fetchableViewController
    }
    
    // MARK: - Instance Functions
    
    public func numberOfSections() -> Int {
        return viewController.fetchedResultsController?.sections?.count ?? 1
    }
    
    public func numberOfItems(in section: Int) -> Int {
        return viewController.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    public func sequenceView<Cell>(_ sequenceView: CellDequeable, cellForItemAt indexPath: IndexPath) -> Cell where Cell : Reusable, Cell : Configurable, Item == Cell.Item {
        let cell = sequenceView.dequeueReusableCell(forIndexPath: indexPath) as Cell
        if let item = viewController.fetchedResultsController?.fetchedObjects?[indexPath.row] as? Item {
            cell.configure(with: item)
        }
        return cell
    }
    
    fileprivate func hasSectionDictionary() -> Bool {
        return sectionDictionary.values.map{$0}.map{$0.isEmpty}.contains(false)
    }
    
    fileprivate func hasRowDictionary() -> Bool {
        return rowDictionary.values.map{$0}.map{$0.isEmpty}.contains(false)
    }
    
    public func willChangeContent() {
        animatedUpdates = UIApplication.shared.applicationState != .background
        guard animatedUpdates else {
            viewController.sequenceView?.reloadData()
            return
        }
        rowDictionary = [.insert : [], .delete : [], .update : [],  .move : []]
        sectionDictionary = [.insert : [], .delete : [], .update : []]
    }
    
    public func didChange(atSectionIndex sectionIndex: Int, forType type: NSFetchedResultsChangeType) {
        guard animatedUpdates else {
            return
        }
        sectionDictionary[type]?.append(sectionIndex)
    }
    
    public func didChange(atIndexPath indexPath: IndexPath?, forType type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard animatedUpdates else {
            return
        }
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            rowDictionary[type]?.append(newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            rowDictionary[type]?.append(indexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            rowDictionary[type]?.append(indexPath)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath  else { return }
            rowDictionary[.delete]?.append(indexPath)
            rowDictionary[.insert]?.append(newIndexPath)
        default:
            break
        }
    }
    
    public func didChangeContent() {
        guard let sequenceView = viewController.sequenceView, animatedUpdates else {
            return
        }
        if hasSectionDictionary() {
            sequenceView.performBatchUpdates({ [unowned self] () -> Void in
                self.sectionDictionary.keys.forEach { type in
                    if let sectionIndexs = self.sectionDictionary[type] {
                        sectionIndexs.forEach { sectionIndex in
                            switch type {
                            case .insert:
                                sequenceView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            case .update:
                                sequenceView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            case .delete:
                                sequenceView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                            default:
                                break
                            }
                        }
                    }
                }
            }) { (success) in
                self.sectionDictionary.removeAll(keepingCapacity: false)
            }
        }
        if hasRowDictionary() {
            sequenceView.performBatchUpdates({ [unowned self] () -> Void in
                self.rowDictionary.keys.forEach { type in
                    if let indexPaths = self.rowDictionary[type] {
                        indexPaths.forEach { indexPath in
                            switch type {
                            case .insert:
                                sequenceView.insertItems(at: [indexPath])
                            case .update:
                                sequenceView.reloadItems(at: [indexPath])
                            case .delete:
                                sequenceView.deleteItems(at: [indexPath])
                            case .move:
                                break
                            default:
                                break
                            }
                        }
                    }
                }
                }, completion: { [unowned self] (finished) -> Void in
                    self.rowDictionary.removeAll(keepingCapacity: false)
                    DispatchQueue.main.async {
                        if sequenceView.refreshControl?.isRefreshing == true {
                            sequenceView.refreshControl?.endRefreshing()
                        }
                    }
            })
        }
    }
    
}

