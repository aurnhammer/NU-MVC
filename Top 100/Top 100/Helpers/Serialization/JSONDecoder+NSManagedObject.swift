//
//  JSONDecoder+NSManagedObject.swift
//  Top 30
//
//  Created by William Aurnhammerurbammer on 1/13/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")
}

extension JSONDecoder {
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }

    convenience init(managedObjectContext: NSManagedObjectContext) {
        self.init()
        guard let codingUserInfoKeyContext = CodingUserInfoKey.context else {
            fatalError("Could not create JSONDecoder for NSManagedObjectContext")
        }
        self.userInfo[codingUserInfoKeyContext] = managedObjectContext
    }
}
