//
//  DelegateCellProvidable.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

public protocol DelegateCellProvidable {
    func willDisplay(cell: Reusable, forItemAt indexPath: IndexPath)
    func didEndDisplaying(cell: Reusable, forItemAt indexPath: IndexPath)
}

extension DelegateCellProvidable {
    func willDisplay(cell: Reusable, forItemAt indexPath: IndexPath) {}
    func didEndDisplaying(cell: Reusable, forItemAt indexPath: IndexPath) {}
}

