//
//  ErrorHandling.swift
//  Top 100
//
//  Created by William Aurnhammerurnhammer on 1/10/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import Foundation

/// Namespace for Errors
enum Errors {
    
    /**
     Error handling
     An error domain, and an error code enumeration.
     */
    static let top100ErrorDomain = "top100ErrorDomain"
    
    enum Top100ErrorCode: NSInteger {
        case networkUnavailable = 101
        case wrongDataFormat = 102
        case wrongURLFormat = 103
        case missingURL = 104
    }
}

