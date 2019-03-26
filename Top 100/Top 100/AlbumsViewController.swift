//
//  AlbumsViewController.swift
//  Aurnhammer
//
//  Created by William Aurnhammerurnhammer on 1/20/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit


final class AlbumsViewController: UIViewController, SequenceFetching  {
    
    lazy var sequenceView: SequenceViewer? = {
        let flowLayout = GridLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BackgroundColor")
        return view
    }()
    
    private lazy var collectionDataSource: CollectionViewDataSource? = { () -> CollectionViewDataSource<FetchedDataSourceProvider<Album>, AlbumCollectionViewCell> in
        let dataSourceProvider = FetchedDataSourceProvider<Album>(withFetchableViewController: self)
        return CollectionViewDataSource(with: dataSourceProvider)
    }()

    private lazy var  collectionDelegate: CollectionViewDelegate? = { () -> CollectionViewDelegate<AlbumsViewDelegateProvider> in
        let delegateProvider = AlbumsViewDelegateProvider(withViewController: self)
        return CollectionViewDelegate(withDelegateProvider: delegateProvider)
    }()
    
    private lazy var tableDataSource: TableViewDataSource = { () -> TableViewDataSource<FetchedDataSourceProvider<Album>, AlbumTableViewCell> in
        let dataHandler = FetchedDataSourceProvider<Album>(withFetchableViewController: self)
        return TableViewDataSource(with: dataHandler)
    }()
    
    private lazy var tableDelegate: TableViewDelegate? = { () -> TableViewDelegate<AlbumsViewDelegateProvider> in
        let delegateProvider = AlbumsViewDelegateProvider(withViewController: self)
        return TableViewDelegate(withDelegateProvider: delegateProvider)
    }()

    // Protocol Conformance to SequenceViewable
    lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject>? = {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Album")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "albumRank", ascending:true)]
        fetchRequest.predicate = NSPredicate.init(format:"TRUEPREDICATE")
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: AlbumData.container.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = collectionDataSource
        
        do {
            try controller.performFetch()
        } catch {
            Log.error(with: #line, functionName: #function, error: error)
        }
        return controller
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
        fetchItems()
        print(sequenceView?.numberOfItems(inSection: 0) ?? -1)
    }
    
    private func setupViews() {
        setupSequenceView(with: sequenceView as! UICollectionView)
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        sequenceView?.addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = NSLocalizedString( "Top 30 Albums", comment: "Used as the title for the main view")
    }
    
    private func setupSequenceView<ViewType>(with sequenceView: ViewType) where ViewType: UICollectionView {
        view.addSubview(sequenceView)
        sequenceView.sequenceDelegate = collectionDelegate
        sequenceView.sequenceDatasource = collectionDataSource
        sequenceView.prefetchDataSource = self
        sequenceView.refreshControl = UIRefreshControl()
        sequenceView.refreshControl?.tintColor = .white
        sequenceView.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        sequenceView.register(AlbumCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        sequenceView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sequenceView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sequenceView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        sequenceView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupSequenceView<ViewType>(with sequenceView: ViewType) where ViewType: UITableView {
        sequenceView.sequenceDelegate = tableDelegate
        sequenceView.sequenceDatasource = tableDataSource
        sequenceView.prefetchDataSource = self
        sequenceView.refreshControl = UIRefreshControl()
        sequenceView.refreshControl?.tintColor = .white
        sequenceView.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        sequenceView.register(AlbumTableViewCell.classForCoder(), forCellWithReuseIdentifier: "AlbumTableViewCell")
        sequenceView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sequenceView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sequenceView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        sequenceView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    // Fetching
    private func fetchItems() {
        if fetchedResultsController?.fetchedObjects == nil {
            loadingView.startAnimating()
        }
        fetchAlbums { [unowned self] _ in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
            }
        }
    }
    
    /// Spins up an Operation to fetch the Albums
    ///
    /// - Parameter completionHandler: ManagedObjects returned by the request. May be nil.
    private func fetchAlbums(completionHandler: @escaping ([NSManagedObject]?) -> Void) {
        guard let url = URL(string: API.top100AlbumsURL) else {
            let description = NSLocalizedString("Could not initialize url", comment: "Used when a URL string is malformed and cannot be intialized to a URL.")
            let error = NSError(domain: Errors.top30ErrorDomain, code: Errors.Top30ErrorCode.wrongURLFormat.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: description])
            Log.error(with: #line, functionName: #function, error: error)
            return
        }
        
        let fetchRSSOperation = FetchAlbumsOperation(with: url)
        
        fetchRSSOperation.fetchAlbumsCompletionBlock = { objects in
            if let objects = objects {
                completionHandler(objects)
            }
        }
        OperationQueue().addOperation(fetchRSSOperation)
    }
    
    
    // MARK: - RefreshControl
    @objc func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        fetchAlbums { [unowned self] _ in
            DispatchQueue.main.async {
                if self.sequenceView?.refreshControl?.isRefreshing == true {
                    self.sequenceView?.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
}

extension AlbumsViewController: UICollectionViewDataSourcePrefetching  {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let fetchedResultsController = fetchedResultsController else {
            return
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Album")
        fetchRequest.returnsObjectsAsFaults = false
        let objects = indexPaths.map({ (index) -> NSManagedObject in
            fetchedResultsController.object(at: index)
        })
        fetchRequest.predicate = NSPredicate(format: "SELF IN %@", objects as CVarArg)
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest,
                                                           completionBlock: nil)
        do {
            try self.fetchedResultsController?.managedObjectContext.execute(asyncFetchRequest)
        } catch {
            fatalError("Failed to execute fetch: \(error)")
        }
        
    }
    
    
}

extension AlbumsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let fetchedResultsController = fetchedResultsController else {
            return
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Album")
        fetchRequest.returnsObjectsAsFaults = false
        let objects = indexPaths.map({ (index) -> NSManagedObject in
            fetchedResultsController.object(at: index)
        })
        fetchRequest.predicate = NSPredicate(format: "SELF IN %@", objects as CVarArg)
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest,
                                                           completionBlock: nil)
        do {
            try self.fetchedResultsController?.managedObjectContext.execute(asyncFetchRequest)
        } catch {
            fatalError("Failed to execute fetch: \(error)")
        }

    }
    
    
}

