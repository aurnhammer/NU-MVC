//
//  MoviesSectionViewModel.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/4/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

class MoviesSectionViewModel: NSObject, CollectionViewModelProtocol, SectionViewModelProtocol {
    
    var cellIdentifier = "MoviesSectionCollectionViewCell"
    
    var update: (() -> Void)?
    
    typealias ViewModel = MovieViewModel
    
    var viewModels: [ViewModel]?
    
    override init() {
        super.init()
    }
    
    init(withMovies movies: [Movie]) {
        self.viewModels = movies.map {
            return ViewModel(withMovie: $0)
        }
    }
    
    deinit {
        print("deinit MoviesSectionViewModel")
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
    
    func object(atIndex index: Int) -> ViewModel? {
        guard let viewModels = viewModels else { return nil }
        return viewModels[index]
    }
    
}

