//
//  AlbumData.swift
//  Top 100
//
//  Created by William Aurnhammerurnhammer on 1/10/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import Foundation
import CoreData

/// Namespace for the Core Data Stack
enum AlbumData {
    
    // MARK: - Core Data stack
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Top_100")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.viewContext.undoManager = nil // We don't need undo so set it to nil.
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

}
