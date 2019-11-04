//
//  AlbumsSectionViewModel.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/1/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

class AlbumsSectionViewModel: NSObject, CollectionViewModelProtocol, SectionViewModelProtocol {
    
    var cellIdentifier = "AlbumsSectionCollectionViewCell"
    
    var update: (() -> Void)?
    
    typealias ViewModel = AlbumViewModel

    var viewModels: [ViewModel]?
    
    override init() {
        super.init()
    }
    
    init(withAlbums albums: [Album]) {
        self.viewModels = albums.map {
            return AlbumViewModel(withAlbum: $0)
        }
    }
    
    deinit {
        print("deinit AlbumsSectionViewModel")
    }
    
    func numberOfSections() -> Int {
        guard viewModels != nil else { return 0 }
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard let viewModels = viewModels,
            !viewModels.isEmpty else { return 1 }
        return viewModels.count
    }

    func viewModel(atIndex index: Int) -> ViewModel? {
        guard let viewModels = viewModels else { return nil }
        return viewModels[index]
    }
    
}

