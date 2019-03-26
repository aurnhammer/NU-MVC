//
//  UILayoutPriorityExtensions.swift
//  Top 30
//
//  Created by William Aurnhammerurnhammer on 1/10/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// Extension to UILayoutPriority to enable setting layout priorities
/// accross multiple constraints.
extension UILayoutPriority {
    
    static func setHorizontalHuggingAndCompressionResistance(_ priority: UILayoutPriority, for view: UIView) {
        view.setContentHuggingPriority(priority, for: .horizontal)
        view.setContentCompressionResistancePriority(priority, for: .horizontal)
    }
    
    static func setVerticalHuggingAndCompressionResistance(_ priority: UILayoutPriority, for view: UIView) {
        view.setContentHuggingPriority(priority, for: .vertical)
        view.setContentCompressionResistancePriority(priority, for: .vertical)
    }
    
    static func setHorizontalAndVerticalHuggingAndCompressionResistance(_ priority: UILayoutPriority, for view: UIView) {
        view.setContentHuggingPriority(priority, for: .horizontal)
        view.setContentHuggingPriority(priority, for: .vertical)
        view.setContentCompressionResistancePriority(priority, for: .horizontal)
        view.setContentCompressionResistancePriority(priority, for: .vertical)
    }
    
}

