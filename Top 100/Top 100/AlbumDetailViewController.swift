//
//  AlbumDetailViewController.swift
//  Aurnhammer
//
//  Created by William Aurnhammerurnhammer on 1/9/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import StoreKit
import UIKit

/// View Controller that manages the display of a single Album
final class AlbumDetailViewController: UIViewController {

    // MAARK - Private Properties
    private var objectID: NSManagedObjectID!
    
    private lazy var album: Album = {
        guard let album = AlbumData.container.viewContext.object(with: objectID) as? Album else {
            fatalError("Album is not the right type or does not exist")
        }
        return album
    }()
    
    private lazy var rootStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageContainerView, labelsContainerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private lazy var imageContainerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
         return view
    }()
    
    private lazy var labelsContainerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [labelsStackView, linkButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [artistsNameLabel, albumNameLabel, releaseDataLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.axis = .vertical
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = true
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.required, for: view)
        view.accessibilityIgnoresInvertColors = true
        return view
    }()
 
    private lazy var artistsNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = -1
        label.textAlignment = .center
        if let font = UIFont(name: "Industry-Demi", size: 18) {
            label.font = font
        }
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultLow, for: label)
        return label
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = -1
        label.textAlignment = .center
        if let font = UIFont(name: "Industry-Demi", size: 24) {
            label.font = font
        }
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultLow, for: label)
        return label
    }()
    
    private lazy var releaseDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        if let font = UIFont(name: "Industry-Demi", size: 18) {
            label.font = font
        }
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultHigh, for: label)
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle(NSLocalizedString("Open in iTunes", comment: "Title of button to open the album description in StoreKit"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TintColor")
        button.addTarget(self, action: #selector(openInITunes), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        if let font = UIFont(name: "Industry-Demi", size: 15) {
            button.titleLabel?.font = font
        }
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        UILayoutPriority.setHorizontalAndVerticalHuggingAndCompressionResistance(.defaultHigh, for: button)
         return button
    }()
    
    // MARK - Constraints
    
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Initializers
    
    /// Initialzer for the Album Detail View Controooer.
    ///
    /// - Parameters:
    ///     - objectID: Injects the NSManagedObjectID
    convenience init(objectID: NSManagedObjectID ) {
        self.init()
        self.objectID = objectID
    }
    
    // MARK - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK - Setup
    
    private func setup() {
        setupViews()
        setupNavigationController()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(rootStackView)
        setupConstraints()
        setupImageView()
        setupLabels()
    }
    
    private func setupNavigationController() {
        guard let navigationController = self.navigationController,
            let view = navigationController.view else {
                Log.message("Could not initialize NavigationControler View")
                return
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        view.layer.cornerRadius = 16.0
        view.clipsToBounds = true
    }
    
    private func setupImageView() {
        if let data = album.albumArtworkThumbnail,
            let image = UIImage(data: data) {
            imageView.image = image
        }
        else {
            imageView.image = UIImage(named: "CellBackground")
            let operation = FetchAlbumImageOperaton(with: album)
            operation.start()
        }
    }
    
    private func setupLabels() {
        artistsNameLabel.text = album.artistName
        albumNameLabel.text = album.albumName
        releaseDataLabel.text = NSLocalizedString("Release Date: " + "\(album.releaseDate ?? "Release Date Unkown")", comment: "Prefix string used to identify the type of date")
    }

    
    // MARK: - Autolayout
    
    private func setupConstraints() {
        
        let layoutPriority: Float = 999
        let squareImageSide: CGFloat = 200
        let buttonHeight: CGFloat = 50
        let margin: CGFloat = 36
        
        // RootStackViewConstraints
        let rootStackViewTopConstraint =
            rootStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        rootStackViewTopConstraint.identifier = "** RootStackViewTopConstraint **"
        let rootStackViewBottomConstraint =
            rootStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin)
        rootStackViewTopConstraint.identifier = "** RootStackViewBottomConstraint **"
        let rootStackViewLeadingConstraint =
            rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin)
        rootStackViewLeadingConstraint.identifier = "** RootStackViewLeadingConstraint **"
        let rootStackViewTrailingConstraint =
            rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
        rootStackViewTrailingConstraint.identifier = "** RootStackViewTrailingConstraint **"
        
        // ImageViewConstraints
        let imageViewHeightAnchorConstraint = imageView.heightAnchor.constraint(equalToConstant: squareImageSide)
        imageViewHeightAnchorConstraint.priority = UILayoutPriority(layoutPriority)
        imageViewHeightAnchorConstraint.identifier = "** ImageViewHeightAnchorConstraint **"
        let imageViewWidthAnchorConstraint = imageView.widthAnchor.constraint(equalToConstant: squareImageSide)
        imageViewWidthAnchorConstraint.priority = UILayoutPriority(layoutPriority)
        imageViewWidthAnchorConstraint.identifier = "** ImageViewWidthAnchorConstraint **"

        // LinkButtonConstraints
        let linkButtonHeightAnchorConstraint = linkButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        linkButtonHeightAnchorConstraint.priority = UILayoutPriority(layoutPriority)
        linkButtonHeightAnchorConstraint.identifier = "** LinkButtonHeightAnchorConstraint **"
        
        sharedConstraints.append(contentsOf:
            [rootStackViewTopConstraint,
             rootStackViewBottomConstraint,
             rootStackViewLeadingConstraint,
             rootStackViewTrailingConstraint,
             imageViewHeightAnchorConstraint,
             imageViewWidthAnchorConstraint,
             linkButtonHeightAnchorConstraint
            ]
        )
        
        let labelStackViewWidthConstraint = labelsStackView.widthAnchor.constraint(equalTo: rootStackView.widthAnchor)
        labelStackViewWidthConstraint.priority = UILayoutPriority(layoutPriority)
        labelStackViewWidthConstraint.identifier = "** LabelStackViewWidthConstraint **"
        
        regularConstraints.append(contentsOf:
            [labelStackViewWidthConstraint]
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if (!sharedConstraints[0].isActive) {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        if traitCollection.verticalSizeClass == .regular || UIDevice.current.userInterfaceIdiom == .pad {
            adjustLayout(for: .regular)
        } else {
            adjustLayout(for: .compact)
        }
    }
    
    private func adjustLayout(for sizeClass: UIUserInterfaceSizeClass) {
        let verticalSpacing: CGFloat = 8
        let horizontalSpacing: CGFloat = 36
        switch sizeClass {
        case .regular:
            rootStackView.axis = .vertical
            rootStackView.spacing = verticalSpacing
            rootStackView.distribution = .fill
            labelsStackView.spacing = verticalSpacing
            labelsStackView.distribution = .equalSpacing
            imageContainerView.axis = .horizontal
            NSLayoutConstraint.activate(regularConstraints)
        default:
            rootStackView.axis = .horizontal
            rootStackView.spacing = horizontalSpacing
            labelsStackView.spacing = 0
            imageContainerView.axis = .vertical
            NSLayoutConstraint.deactivate(regularConstraints)
        }
    }
    
    // MARK: - Navigation
    @objc func doneButtonPressed() {
        dismiss(animated: true)
    }
    
 }

extension AlbumDetailViewController: SKStoreProductViewControllerDelegate {
    
    static let storeViewController  = SKStoreProductViewController()

    @objc private func openInITunes() {
        guard let identifier = album.itunesLink?.lastPathComponent else {
            let description = NSLocalizedString("Could not parse iTunes Link", comment: "Link identifier was not able to be parsed from the selected URL")
            let error = NSError(domain: Errors.top30ErrorDomain, code: Errors.Top30ErrorCode.wrongURLFormat.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: description])
            Log.error(with: #line, functionName: #function, error: error)
            return
        }
        openStoreProductWithiTunesItemIdentifier(identifier: identifier)
    }

    private func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        
        AlbumDetailViewController.storeViewController.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier: identifier]
        AlbumDetailViewController.storeViewController.loadProduct(withParameters: parameters) { [unowned self] (loaded, error) -> Void in
            if loaded {
                self.present(AlbumDetailViewController.storeViewController, animated: true)
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}
