//
//  Delegate.swift
//  Top 100
//
//  Created by Bill A on 2/4/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

/// Storage for our Object that confroms to DataProvidable
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
