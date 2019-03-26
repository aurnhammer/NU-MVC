//
//  DelegateProvidable.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

/// An object that adopts the DelegateProvidable protocol is responsible for notification of selection/deselection and highlight/unhighlight events.
public protocol DelegateProvidable {
    var selectionProvider: DelegateSelectionProvideable? { get }
    var highlightProvider: DelegateHighlightProvideable? { get }
    var cellProvider: DelegateCellProvidable? { get }
    var suplimentaryViewProvider: DelegateSuplimentaryViewProvidable? { get }
}

extension DelegateProvidable {
    var selectionProvider: DelegateSelectionProvideable? { return nil }
    var highlightProvider: DelegateHighlightProvideable? { return nil }
    var cellProvider: DelegateCellProvidable? { return nil }
    var suplimentaryViewProvider: DelegateSuplimentaryViewProvidable? { return nil }
}

