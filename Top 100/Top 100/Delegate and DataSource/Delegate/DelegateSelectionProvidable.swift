//
//  DelegateSelectionProvidable.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

public protocol DelegateSelectionProvideable: DelegateProvidable {
    func didSelect(itemAt indexPath: IndexPath)
    func didDeselect(itemAt indexPath: IndexPath)
}

extension DelegateSelectionProvideable {
    func didSelect(itemAt indexPath: IndexPath) {}
    func didDeselect(itemAt indexPath: IndexPath) {}
}

