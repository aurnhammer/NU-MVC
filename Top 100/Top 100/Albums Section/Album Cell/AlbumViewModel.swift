//
//  AlbumViewModel.swift
//  Top 100
//
//  Created by William Aurnhammer on 10/29/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

protocol AlbumViewModelProtocol: NSObjectProtocol {
    var updateArtworkUrl100: ((URL?) -> Swift.Void)? { get set }
    var updateArtworkThumbnailData: ((Data?) -> Swift.Void)? { get set }
}

class AlbumViewModel: NSObject, CollectionViewModelProtocol, AlbumViewModelProtocol {
        
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

    init(withAlbum album: Album) {
        super.init()
        configure(with: album)
    }
    
    deinit {
        print("deinit AlbumViewModel")
    }
    
    private func configure(with album: Album) {
        artworkUrl100 = album.artworkUrl100
        artworkThumbnailData = album.artworkThumbnailData
        name = album.name
        artistName = album.artistName
        url = album.url
        releaseDate = album.releaseDate
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return 1
    }


}
