//
//  DelegateCellProvidable.swift
//  Top 100
//
//  Created by Bill A on 2/20/19.
//  Copyright © 2019 District-1. All rights reserved.
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

