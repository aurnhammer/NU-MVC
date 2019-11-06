//
//  MoviesSectionCollectionViewCell.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/4/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit

class MoviesSectionCollectionViewCell: UICollectionViewCell, SectionModelConfigurable, Layoutable, Themeable {
    
    typealias SectionViewModel = MoviesSectionViewModel
    
    private weak var presentationController: Presentable?
    private var sectionViewModel: SectionViewModel?
    private var cellLayout: MovieCellLayout?
    private var cellTheme: MovieCellTheme?
    
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
        self.sectionViewModel = model as? MoviesSectionCollectionViewCell.SectionViewModel
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
    }
    
    private func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.classForCoder(), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
        
    // Fetching
    private func fetchItems() {
        if sectionViewModel == nil {
        }
        fetchMovies { [weak self] in
            DispatchQueue.main.async {
            }
        }
    }
    
    /// Spins up an Operation to fetch the Albums
    ///
    /// - Parameter completionHandler: ManagedObjects returned by the request. May be nil.
    private func fetchMovies(completionHandler: @escaping () -> Void) {
        guard let url = URL(string: API.topMoviesURL) else {
            let description = NSLocalizedString("Could not initialize url", comment: "Used when a URL string is malformed and cannot be intialized to a URL.")
            let error = NSError(domain: Errors.top100ErrorDomain, code: Errors.Top100ErrorCode.wrongURLFormat.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: description])
            Log.error(with: #line, functionName: #function, error: error)
            return
        }
        
        let fetchRSSOperation = NetworksOperation<Movie>(with: url)
        
        fetchRSSOperation.fetchNetworkOperationCompletionBlock = { [weak self] movies in
            guard let movies = movies else { completionHandler(); return }
            self?.sectionViewModel = MoviesSectionViewModel(withMovies: movies)
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        OperationQueue().addOperation(fetchRSSOperation)
    }
    
}

extension MoviesSectionCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionViewModel = sectionViewModel else { return 0 }
        return sectionViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionViewModel = sectionViewModel else { return 0 }
        return sectionViewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath)
        if let cell = cell as? MovieCell,
            let object = sectionViewModel?.object(atIndex:indexPath.row) {
            cell.configure(withModel: object)
        }
        else {
            fetchItems()
        }
        return cell
    }
}

extension MoviesSectionCollectionViewCell: UICollectionViewDelegate {
    
}



