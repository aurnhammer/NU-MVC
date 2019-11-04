//
//  AlbumCellLayout.swift
//  Top 100
//
//  Created by William Aurnhammer on 1/31/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// A Struct that instantiates the views contained in a cell and their constraints
struct AlbumCellLayout {
    
    private var rootView: UIView
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "CellBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    
    private lazy var gradiantView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "Gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()
    
    private lazy var rootStackView: UIStackView = {
        let rootView = UIStackView(arrangedSubviews: [albumRankLabel, UIView(), albumNameLabel, artistsNameLabel])
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.axis = .vertical
        rootView.alignment = .center
        rootView.distribution = .fill
        return rootView
    }()
    
    lazy var albumRankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = -1
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        if let font = UIFont(name: "Industry-Demi", size: 12) {
            label.font = font
        }
        return label
    }()
    
    
    lazy var artistsNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = -1
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        if let font = UIFont(name: "Industry-Demi", size: 12) {
            label.font = font
        }
        return label
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = -1
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        if let font = UIFont(name: "Industry-Demi", size: 16) {
            label.font = font
        }
        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    /// Initialzer for the AlbumCellLayout.
    ///
    /// - Parameters:
    ///     - view: Injects the UIView
    init(for view: UIView) {
        self.rootView = view
        layout()
    }
    
    // MARK: - Layout
    mutating private func layout() {
        rootView.addSubview(imageView)
        rootView.addSubview(gradiantView)
        rootView.addSubview(rootStackView)
        rootView.addSubview(loadingView)
        setupCornerRadius()
        setupAutoLayout()
    }
    
    private func setupCornerRadius() {
        rootView.layer.cornerRadius = 8
        rootView.layer.masksToBounds = true
    }
    
    private mutating func setupAutoLayout() {
        imageView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
        
        gradiantView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
        gradiantView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
        gradiantView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        gradiantView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
        
        let margin: CGFloat = 8
        rootStackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: margin).isActive = true
        rootStackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -margin).isActive = true
        rootStackView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: margin).isActive = true
        rootStackView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -margin).isActive = true
        
        
        loadingView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
        
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultHigh, for: artistsNameLabel)
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultLow, for: albumRankLabel)
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.required, for: albumNameLabel)
    }
}

