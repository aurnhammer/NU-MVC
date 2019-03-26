//
//  UICollectionView + UITableView + Extensions.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/3/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

enum SequenceType {
    case tableView
    case collectionView
}

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

/// Protocol conformance to enable a Table View to dequeue a reusable cell based on its class name
extension UITableView: CellDequeable {
    
    public func dequeueReusableCell<Cell>(forIndexPath indexPath: IndexPath) -> Cell where Cell : Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
}

public protocol SequenceCell {
    var bounds: CGRect { get }
    var frame: CGRect { get }
    var layer: CALayer { get }
    var isSelected: Bool { get set }
    
   init(frame: CGRect)
}

extension UICollectionViewCell: SequenceCell {}
extension UITableViewCell: SequenceCell {}

/// A ViewController that conforms to SequenceViewing must implement an instance of a SequenceViewer
public protocol SequenceViewing {
    var navigationController: UINavigationController? { get }
    var sequenceView: SequenceViewer? { get }
}

/// A ViewController that conforms to SequenceFetching must implement an instance of NSFetchedResultsController.
public protocol SequenceFetching: SequenceViewing {
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>? { get }
}

/// Conformance to ItemsView bridges datasource methods between a UICollectionView and a UITableView
public protocol SequenceViewer {
    
    var refreshControl: UIRefreshControl? { get set }
    var numberOfSections: Int { get }
    var sequenceDelegate: UIScrollViewDelegate? { get set }
    var sequenceDatasource: NSObjectProtocol? { get set }
    
    func addSubview(_: UIView)
    func reloadData()
    func numberOfItems(inSection section: Int) -> Int

    func insertSections(_: IndexSet)
    func reloadSections(_: IndexSet)
    func deleteSections(_: IndexSet)
    func moveSection(_: Int, toSection newSection: Int)
    
    func insertItems(at indexPaths: [IndexPath])
    func deleteItems(at indexPaths: [IndexPath])
    func reloadItems(at indexPaths: [IndexPath])
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String)

    func sequenceCell(at indexPath: IndexPath) -> SequenceCell?
    func deselectItem(at indexPath: IndexPath, animated: Bool)
    
    func convert(_ point: CGPoint, to view: UIView?) -> CGPoint
    func convert(_ point: CGPoint, from view: UIView?) -> CGPoint
    func convert(_ rect: CGRect, to view: UIView?) -> CGRect
    func convert(_ rect: CGRect, from view: UIView?) -> CGRect
 }

extension UICollectionView: SequenceViewer {
    
    public var sequenceDelegate: UIScrollViewDelegate? {
        get {
            return delegate
        }
        set {
            delegate = newValue as? UICollectionViewDelegate
        }
    }
    
    public var sequenceDatasource: NSObjectProtocol? {
        get {
            return dataSource
        }
        set {
            dataSource = newValue as? UICollectionViewDataSource
        }
    }

    public func sequenceCell(at indexPath: IndexPath) -> SequenceCell? {
        return cellForItem(at:indexPath)
    }
    
}

extension UITableView: SequenceViewer {
    
    public var sequenceDelegate: UIScrollViewDelegate? {
        get {
            return delegate
        }
        set {
            delegate = newValue as? UITableViewDelegate
        }
    }
    
    public var sequenceDatasource: NSObjectProtocol? {
        get {
            return dataSource
        }
        set {
            dataSource = newValue as? UITableViewDataSource
        }
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }

    public func insertSections(_ sections: IndexSet) {
        insertSections(sections, with: .automatic)
    }
    
    public func reloadSections(_ sections: IndexSet) {
        reloadSections(sections, with: .automatic)
    }
    
    public func deleteSections(_ sections: IndexSet) {
        deleteSections(sections, with: .automatic)
    }
    
    public func insertItems(at indexPaths: [IndexPath]) {
        insertRows(at: indexPaths, with: .automatic)
    }
    
    public func deleteItems(at indexPaths: [IndexPath]) {
        deleteRows(at: indexPaths, with: .automatic)
    }
    
    public func reloadItems(at indexPaths: [IndexPath]) {
        reloadRows(at: indexPaths, with: .automatic)
    }
    
    public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        moveRow(at:indexPath, to: newIndexPath)
    }
    
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func sequenceCell(at indexPath: IndexPath) -> SequenceCell? {
        return cellForRow(at: indexPath)
    }
    
    public func deselectItem(at indexPath: IndexPath, animated: Bool) {
        deselectRow(at: indexPath, animated: animated)
    }
    
}
