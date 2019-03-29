//
//  Delegate.swift
//  Top 100
//
//  Created by William Aurnhammer on 2/4/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// Storage for our Object that confroms to DelegateProvidable
class Delegate<Provider: DelegateProvidable>: NSObject {
    
    // MARK: - Private Properties
    public let delegateProvider: Provider
    
    // MARK: - Initialzier
    
    /// Our initializer
    /// - Parameters:
    ///    - delegateProvider : an items that conforms to DelegateProvidable.
    public init(withDelegateProvider delegateProvider: Provider) {
        self.delegateProvider = delegateProvider
        super.init()
    }
}
