//
//  AlbumViewCell.swift
//  Aurnhammer
//
//  Created by William Aurnhammerurnhammer on 1/8/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit



/// The Cell that manages the display an Album
final class AlbumCollectionViewCell: UICollectionViewCell, Configurable, Layoutable {
    
    // The type that the cell is displaying
    typealias Item = Album

    // Public properties
    var album: Item?
    
    // Private properties
    private var albumCellLayout: AlbumCellLayout?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    deinit {
        print ("Remove Cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        if albumCellLayout == nil {
            albumCellLayout = AlbumCellLayout(for: self)
        }
    }

    // MARK - Public Functions
    
    /// Sets up the Cell’s private properties after it has been dequeued.
    ///
    /// - Parameters:
    ///   - album: The Album for each cell
    func configure(with item: Item) {
        self.album = item
        setupLabels()
        setupImage()
    }
    
    private func setupImage() {
        guard let album = album else {
            return
        }
        if let data = album.albumArtworkThumbnail,
            let image = UIImage(data: data) {
            albumCellLayout?.imageView.image = image
            albumCellLayout?.loadingView.stopAnimating()
        }
        else {
            albumCellLayout?.imageView.image = UIImage.init(named: "CellBackground")
            albumCellLayout?.loadingView.startAnimating()
            let operation = FetchAlbumImageOperaton(with: album)
            operation.start()
        }
    }

    private func setupLabels() {
        albumCellLayout?.albumRankLabel.text = "\(album?.albumRank != nil ? album!.albumRank + 1 : -1)"
        albumCellLayout?.artistsNameLabel.text = album?.artistName
        albumCellLayout?.albumNameLabel.text = album?.albumName
    }
}

/// The Cell that manages the display an Album
final class AlbumTableViewCell: UITableViewCell, Configurable, Layoutable {
    
    // The type that the cell is displaying
    typealias Item = Album
    
    // Public properties
    var album: Item?
    
    // Private properties
    private var albumCellLayout: AlbumCellLayout?
    
    // Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    deinit {
        print ("Remove Cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        if albumCellLayout == nil {
            albumCellLayout = AlbumCellLayout(for: self)
        }
    }
    
    // MARK - Public Functions
    
    /// Sets up the Cell’s private properties after it has been dequeued.
    ///
    /// - Parameters:
    ///   - album: The Album for each cell
    func configure(with item: Item) {
        self.album = item
        setupLabels()
        setupImage()
    }
    
    private func setupImage() {
        guard let album = album else {
            return
        }
        if let data = album.albumArtworkThumbnail,
            let image = UIImage(data: data) {
            albumCellLayout?.imageView.image = image
            albumCellLayout?.loadingView.stopAnimating()
        }
        else {
            albumCellLayout?.imageView.image = UIImage.init(named: "CellBackground")
            albumCellLayout?.loadingView.startAnimating()
            let operation = FetchAlbumImageOperaton(with: album)
            operation.start()
        }
    }
    
    private func setupLabels() {
        albumCellLayout?.albumRankLabel.text = "\(album?.albumRank != nil ? album!.albumRank + 1 : -1)"
        albumCellLayout?.artistsNameLabel.text = album?.artistName
        albumCellLayout?.albumNameLabel.text = album?.albumName
    }
}
