//
//  DelegateSelectionProvidable.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// An object that adopts the DelegateSelectionProvideable protocol is responsible for notification of didSelect/didDeselect events.
public protocol DelegateSelectionProvideable: DelegateProvidable {
    func didSelect(itemAt indexPath: IndexPath)
    func didDeselect(itemAt indexPath: IndexPath)
}

extension DelegateSelectionProvideable {
    func didSelect(itemAt indexPath: IndexPath) {}
    func didDeselect(itemAt indexPath: IndexPath) {}
}

