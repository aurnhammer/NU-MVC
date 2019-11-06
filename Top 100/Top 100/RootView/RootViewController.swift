//
//  RootViewController.swift
//  Top 100
//
//  Created by William Aurnhammerurnhammer on 1/20/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import CoreData
import UIKit

/// View Controller that manages the display of a list of Albums
final class RootViewController: UIViewController  {
    
    private var rootViewModel = RootViewModel()

    private lazy var collectionView: UICollectionView? = {
        let layout = ListLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // Setup
    private func setup() {
        setupNavigationController()
        setupViews()
    }
    
    private func setupViews() {
        setupCollectionView()
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        collectionView?.addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        loadingView.startAnimating()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = NSLocalizedString( "Top Albums", comment: "Used as the title for the main view")
    }
    
    private func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        collectionView.register(AlbumsSectionCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "AlbumsSectionCollectionViewCell")
        collectionView.register(MoviesSectionCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "MoviesSectionCollectionViewCell")
        collectionView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
            
    // MARK: - RefreshControl
    @objc func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        self.collectionView?.refreshControl?.endRefreshing()
//        fetchSections { [unowned self] _ in
//            DispatchQueue.main.async {
//                if self.collectionView?.refreshControl?.isRefreshing == true {
//                    self.collectionView?.refreshControl?.endRefreshing()
//                }
//            }
//        }
    }
    
}

extension RootViewController: UICollectionViewDataSource {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rootViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootViewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionIndex = indexPath.section
        let viewModel = rootViewModel.object(atIndex: sectionIndex) as? SectionViewModelProtocol
        let cellIdentifier = viewModel?.cellIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier ?? "", for: indexPath)
        if let cell = cell as? SectionModelConfigurable,
            let viewModel = rootViewModel.object(atIndex: sectionIndex) as? SectionViewModelProtocol {
            cell.configure(withSectionModel: viewModel, presenter: self)
        }
        return cell
    }
 }

extension RootViewController: UICollectionViewDelegate {
    
}

extension RootViewController: Presentable {
    func present(_ viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }

}
