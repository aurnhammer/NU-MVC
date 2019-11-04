//
//  MovieCell.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/4/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

/// The CollectionViewCell that manages the display an Album
final class MovieCell: UICollectionViewCell, Configurable, Layoutable, Themeable {
    
    
    typealias ViewModel = MovieViewModel
    // Public properties
    
    // Private properties
    private var viewModel: ViewModel?
    private var cellLayout: MovieCellLayout?
    private var cellTheme: MovieCellTheme?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        theme()
    }
    
    deinit {
        print ("Remove AlbumCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        if cellLayout == nil {
            cellLayout = MovieCellLayout(for: self)
        }
    }
    
    func theme() {
        if cellTheme == nil {
            cellTheme = MovieCellTheme(for: self)
        }
    }
    
    func bind() {
        viewModel?.updateArtworkThumbnailData = { [weak self] data in
            self?.updateImageView(withData: data)
        }
    }
    
    // MARK - Public Functions
    
    /// Sets up the Cell’s private properties after it has been dequeued.
    ///
    /// - Parameters:
    ///   - album: The Album for each cell
    func configure(withModel model: ViewModel) {
        self.viewModel = model
        setup()
    }
    
    private func setup() {
        setupLabels()
        setupImage()
        bind()
    }
    
    private func setupLabels() {
        cellLayout?.artistsNameLabel.text = viewModel?.artistName
        cellLayout?.albumNameLabel.text = viewModel?.name
    }
    
    private func setupImage() {
        guard let viewModel = viewModel else { return }
        if let artworkThumbnailData = viewModel.artworkThumbnailData {
            updateImageView(withData: artworkThumbnailData)
        }
        else {
            self.cellLayout?.imageView.image = UIImage(named: "CellBackground")
            guard let url = viewModel.artworkUrl100 else { return }
            let operation = FetchImageOperaton(with: url)
            operation.fetchImageOperationCompletionBlock = { data in
                viewModel.artworkThumbnailData = data
            }
            operation.start()
        }
    }

    private func updateImageView(withData data: Data?) {
        guard let data = data else { return }
        DispatchQueue.main.async {
            self.cellLayout?.imageView.image = UIImage(data: data)
        }
    }
}
