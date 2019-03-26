//
//  AlbumsOperations.swift
//  Aurnhammer
//
//  Created by William Aurnhammerurnhammer on 1/10/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

final class DataManager {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        dataTask.resume()
    }
}

/// An Operation wrapping a URL Request. Used to Fetch Albums from Apple's iTunes RSS Feed
final class FetchAlbumsOperation: AsynchronousOperation {
    // Public
    var fetchAlbumsCompletionBlock: (([Album]?) -> Swift.Void)?
    // Private
    private var fetchedObejcts: [Album]? = nil
    private var url: URL!
    private var error: Error? = nil
    private let internetReachability: Reachability = Reachability()!
    
    // Initializer
    public convenience init(with url: URL) {
        self.init()
        self.url = url
    }
    // Operation Start
    override public func main() {
        NetworkActivityIndicator.shared.incrementActivityIndicator()
        guard internetReachability.currentReachabilityStatus != .notReachable else {
            let description = NSLocalizedString("Could not get data from the remote server", comment: "")
            error = NSError(domain: Errors.top30ErrorDomain, code: Errors.Top30ErrorCode.networkUnavailable.rawValue,
                            userInfo: [NSLocalizedDescriptionKey: description])
            finish()
            return
        }
        let dataProvider = DataManager(session:  URLSession.shared)
        dataProvider.fetchData(from: url) { (data, response, error) in
            do {
                guard
                    nil == error,
                    let data = data,
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                    let jsonResults = jsonDictionary["feed"]?["results"] as? [Any]
                    else {
                        self.error = error
                        self.finish()
                        return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResults, options: [])
                let backgroundContext = AlbumData.container.newBackgroundContext()
                backgroundContext.mergePolicy = NSOverwriteMergePolicy
                backgroundContext.undoManager = nil
                backgroundContext.performAndWait { [unowned self] in
                    do {
                        self.fetchedObejcts = try self.parseResults(data: jsonData, in: backgroundContext)
                        try backgroundContext.save()
                    }
                    catch {
                        self.error = error
                    }
                    self.finish()
                }
            }
            catch {
                self.error = error
                self.finish()
            }
        }
    }
    
    private func parseResults(data: Data, in context: NSManagedObjectContext) throws -> [Album] {
        let decoder = JSONDecoder(managedObjectContext: context)
        return try decoder.decode([Album].self, from: data)
    }
    
    // Operation Finish
    private func finish() {
        Log.error(with: #line, functionName: #function, error: error)
        self.fetchAlbumsCompletionBlock?(fetchedObejcts)
        self.state(.finished)
        NetworkActivityIndicator.shared.decrementActivityIndicator()
    }
}

final class FetchAlbumImageOperaton: AsynchronousOperation {
    
    // Public
    var fetchImageOperationCompletionBlock: ((UIImage?) -> Swift.Void)?
    // Private
    private let queue = DispatchQueue(label: "com.top_100.album_image",
                                      qos: .userInteractive,
                                      attributes: .concurrent,
                                      autoreleaseFrequency: .inherit,
                                      target: nil)
    private var fetchedImage: UIImage? = nil
    private var album: Album!
    private var error: Error? = nil
    private var session = URLSession.shared
    
    // Initializer
    public convenience init(with album: Album) {
        self.init()
        self.album = album
    }
    // Operation Start
    override public func main() {
        NetworkActivityIndicator.shared.incrementActivityIndicator()
        guard let url = album.albumArtworkURL else {
            let description = NSLocalizedString("URL Does Not Exist", comment: "A properly formatted URL was not found")
            error = NSError(domain: Errors.top30ErrorDomain, code: Errors.Top30ErrorCode.missingURL.rawValue,
                            userInfo: [NSLocalizedDescriptionKey: description])
            finish()
            return
        }
        queue.async {
            self.session.dataTask(with: url) { (data, response, error) in
                guard nil == error,
                    let data = data else {
                        self.error = error
                        self.finish()
                        return
                }
                let backgroundContext = AlbumData.container.newBackgroundContext()
                backgroundContext.performAndWait {
                    self.fetchedImage = UIImage(data: data)
                    self.album.albumArtworkThumbnail = data
                    if backgroundContext.hasChanges {
                        do {
                            try backgroundContext.save()
                        }
                        catch {
                            self.error = error
                        }
                    }
                    self.finish()
                }
                }.resume()
        }
    }
    // Operation Finish
    private func finish() {
        Log.error(with: #line, functionName: #function, error: error)
        self.fetchImageOperationCompletionBlock?(fetchedImage)
        self.state(.finished)
        NetworkActivityIndicator.shared.decrementActivityIndicator()
    }
}
