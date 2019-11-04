//
//  AlbumViewCell.swift
//  Aurnhammer
//
//  Created by William Aurnhammerurnhammer on 1/8/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// The CollectionViewCell that manages the display an Album
final class AlbumCell: UICollectionViewCell, Configurable, Layoutable, Themeable {
    
    // Public properties
    
    // Private properties
    private var viewModel: AlbumViewModel?
    private var cellLayout: AlbumCellLayout?
    private var cellTheme: AlbumCellTheme?
   
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
            cellLayout = AlbumCellLayout(for: self)
        }
    }
    
    func theme() {
        if cellTheme == nil {
            cellTheme = AlbumCellTheme(for: self)
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
    ///   - model: The Album for each cell
    func configure(withModel model: AlbumViewModel) {
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
