//
//  AlbumsSectionCollectionViewCell.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/1/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit


class AlbumsSectionCollectionViewCell: UICollectionViewCell, SectionModelConfigurable, Layoutable, Themeable {
    
    typealias SectionViewModel = AlbumsSectionViewModel
    
    static private var transitioningCoordinator: UIViewControllerTransitioningDelegate?
    private weak var presentationController: Presentable?
    private var sectionViewModel: SectionViewModel?
    private var cellLayout: AlbumCellLayout?
    private var cellTheme: AlbumCellTheme?
    

    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView? = {
        let layout = GridLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = false
        view.backgroundColor = UIColor(named: "BackgroundColor")
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        theme()
        fetchItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(withSectionModel model: SectionViewModelProtocol, presenter: Presentable) {
        self.sectionViewModel = model as? SectionViewModel
        self.presentationController = presenter
        setup()
    }
    
    func setup() {
        setupViews()
        bind()
    }
        
    func layout() {
    }
        
    func theme() {
    }
     
    func bind() {
        sectionViewModel?.update = { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    private func setupViews() {
        setupCollectionView()
        setupLoadingView()
    }

    private func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumCell.classForCoder(), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupLoadingView() {
        
    }

    // Fetching

    /// Spins up an Operation to fetch the Albums
    ///
    /// - Parameter completionHandler: ManagedObjects returned by the request. May be nil.
    private func fetchItems() {
        guard let url = URL(string: API.topAlbumsURL) else {
            let description = NSLocalizedString("Could not initialize url", comment: "Used when a URL string is malformed and cannot be intialized to a URL.")
            let error = NSError(domain: Errors.top100ErrorDomain, code: Errors.Top100ErrorCode.wrongURLFormat.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: description])
            Log.error(with: #line, functionName: #function, error: error)
            return
        }
        
        let fetchRSSOperation = NetworksOperation<Album>(with: url)
        
        fetchRSSOperation.fetchNetworkOperationCompletionBlock = { [weak self] albums in
            guard let albums = albums else { return }
            self?.sectionViewModel = AlbumsSectionViewModel(withAlbums: albums)
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        OperationQueue().addOperation(fetchRSSOperation)
    }
    
}

extension AlbumsSectionCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionViewModel = sectionViewModel else { return 0 }
        return sectionViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionViewModel = sectionViewModel else { return 0 }
        return sectionViewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath)
        if let cell = cell as? AlbumCell,
            let viewModel = sectionViewModel?.viewModel(atIndex:indexPath.row) {
            cell.configure(withModel: viewModel)
        }
        else {
            fetchItems()
        }
        return cell
    }
 }

extension AlbumsSectionCollectionViewCell: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionViewModel = sectionViewModel,
            let viewModel = sectionViewModel.viewModel(atIndex:indexPath.row) else { return }
        
        let detailViewController = AlbumDetailViewController(albumViewModel: viewModel)
        let destinationViewController = UINavigationController(rootViewController: detailViewController)
        
        AlbumsSectionCollectionViewCell.transitioningCoordinator = ViewControllerTransitioningCoordinator(with: collectionView, for: indexPath)
        destinationViewController.transitioningDelegate = AlbumsSectionCollectionViewCell.transitioningCoordinator
        
        destinationViewController.modalPresentationStyle = .custom
        presentationController?.present(destinationViewController)
    }
    
}


