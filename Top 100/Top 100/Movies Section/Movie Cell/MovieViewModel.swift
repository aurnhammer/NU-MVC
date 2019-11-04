//
//  MovieViewModel.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/4/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

protocol MovieViewModelProtocol: NSObjectProtocol {
    
    var updateArtworkUrl100: ((URL?) -> Swift.Void)? { get set }
    var updateArtworkThumbnailData: ((Data?) -> Swift.Void)? { get set }
    
}

class MovieViewModel: NSObject, CollectionViewModelProtocol, MovieViewModelProtocol {
    
    var updateArtworkUrl100: ((URL?) -> Void)?
    var updateArtworkThumbnailData: ((Data?) -> Void)?
    
    var albumRank: Int? = 1
    
    var artworkUrl100: URL? {
        didSet {
            guard let url = artworkUrl100 else { return }
            updateArtworkUrl100?(url)
        }
    }
    
    var artworkThumbnailData: Data? {
        didSet {
            guard let data = artworkThumbnailData else { return }
            updateArtworkThumbnailData?(data)
        }
    }
    
    var name: String?
    
    var artistName: String?
    
    var url: URL?
    
    var releaseDate: String?
    
    init(withMovie movie: Movie) {
        super.init()
        configure(with: movie)
    }

    deinit {
        print("deinit MovieViewModel")
    }

    private func configure(with movie: Movie) {
        artworkUrl100 = movie.artworkUrl100
        artworkThumbnailData = movie.artworkThumbnailData
        name = movie.name
        artistName = movie.artistName
        url = movie.url
        releaseDate = movie.releaseDate
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
    
    
}
