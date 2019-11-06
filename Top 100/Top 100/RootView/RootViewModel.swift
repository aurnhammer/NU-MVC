//
//  RootViewModel.swift
//  Top 100
//
//  Created by William Aurnhammer on 10/30/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit

protocol CollectionViewModelProtocol: NSObjectProtocol {
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int
}

public protocol SectionViewModelProtocol: NSObjectProtocol {
    var cellIdentifier: String { get }
    var update: (() -> Swift.Void)? { get set }
}

class RootViewModel: NSObject, CollectionViewModelProtocol {
    
    let viewModels: [CollectionViewModelProtocol] =
        [AlbumsSectionViewModel(), MoviesSectionViewModel(), AlbumsSectionViewModel(), MoviesSectionViewModel(), AlbumsSectionViewModel(), MoviesSectionViewModel(), AlbumsSectionViewModel(), MoviesSectionViewModel()]
    
    deinit {
        print("deinit RootViewModel")
    }

    
    func numberOfSections() -> Int {
        return viewModels.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
    
    func object(atIndex index: Int) -> CollectionViewModelProtocol? {
        return viewModels[index]
    }

}
