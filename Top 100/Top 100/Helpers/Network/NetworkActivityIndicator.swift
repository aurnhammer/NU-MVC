//
//  NetworkActivityIndicator.swift
//  Top 30
//
//  Created by William Aurnhammer on 4/29/17.
//  Copyright © 2017 aurnhammer.com. All rights reserved.
//

import UIKit

open class NetworkActivityIndicator: NSObject  {

	public static let shared = NetworkActivityIndicator()
    var count: Int = 0
    open var isVisible: Bool {
        get {
            return UIApplication.shared.isNetworkActivityIndicatorVisible
        }
    }

    fileprivate override init() {
        super.init()
    }

    open func incrementActivityIndicator() {
        DispatchQueue.main.async { [unowned self] in
            self.count += 1
            if self.count >= 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }

    open func decrementActivityIndicator() {
        DispatchQueue.main.async { [unowned self] in
            self.count -= 1
            if self.count <= 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

}
