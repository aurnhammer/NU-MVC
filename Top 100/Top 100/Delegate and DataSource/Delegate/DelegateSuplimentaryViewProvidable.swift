//
//  DelegateSuplimentaryViewProvidable.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

public protocol DelegateSuplimentaryViewProvidable {
    func willDisplay(supplementaryView: UIView, forItemAt indexPath: IndexPath)
    func didEndDisplaying(supplementaryView: UIView, forItemAt indexPath: IndexPath)
}

extension DelegateSuplimentaryViewProvidable {
    func willDisplay(supplementaryView: UIView, forItemAt indexPath: IndexPath) {}
    func didEndDisplaying(supplementaryView: UIView, forItemAt indexPath: IndexPath) {}
}
