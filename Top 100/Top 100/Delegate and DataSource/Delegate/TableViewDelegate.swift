//
//  TableViewDelegate.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// A TableViewDelegate is a concrete subclass of UITableViewDelegate that vends the UITableViewDelegate's responsibilites to an object the conforms to DelegateProvidable.
final class TableViewDelegate<Provider: DelegateSelectionProvideable>: Delegate<Provider>, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateProvider.didSelect(itemAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegateProvider.didDeselect(itemAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        delegateProvider.highlightProvider?.didHighlight(itemAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        delegateProvider.highlightProvider?.didUnhighlight(itemAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegateProvider.cellProvider?.willDisplay(cell: cell, forItemAt: indexPath)
    }
    
}
