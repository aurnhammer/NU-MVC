//
//  NetworksOperation.swift
//  Top 100
//
//  Created by William Aurnhammerurnhammer on 1/10/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit

fileprivate struct FetchImage {
    /// The local cache
    static let cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "ImageCache"
        cache.countLimit = 20 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
}

/// An Operation wrapping a URL Request. Used to Fetch Items from Apple's iTunes RSS Feed
final class NetworksOperation<Item>: AsynchronousOperation where Item: Codable {
    
    // Public
    var fetchNetworkOperationCompletionBlock: (([Item]?) -> Swift.Void)?
    // Private
    private var fetchedObjects: [Item]? = nil
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
            error = NSError(domain: Errors.top100ErrorDomain, code: Errors.Top100ErrorCode.networkUnavailable.rawValue,
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
                    let jsonResults = jsonDictionary["feed"]?["results"] as? [[String: AnyObject]]
                    else {
                        self.error = error
                        self.finish()
                        return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResults, options: [])
                let decoder = JSONDecoder()
                let objects = try decoder.decode([Item].self, from: jsonData)
                self.fetchedObjects = objects
                self.finish()
            }
            catch {
                self.error = error
                self.finish()
            }
        }
    }

    
    // Operation Finish
    private func finish() {
        Log.error(with: #line, functionName: #function, error: error)
        self.fetchNetworkOperationCompletionBlock?(fetchedObjects)
        self.state(.finished)
        NetworkActivityIndicator.shared.decrementActivityIndicator()
    }
}

final class FetchImageOperaton: AsynchronousOperation {
    
    // Public
    var fetchImageOperationCompletionBlock: ((Data?) -> Swift.Void)?
    // Private
    private let queue = DispatchQueue(label: "com.iheart.image",
                                      qos: .userInteractive,
                                      attributes: .concurrent,
                                      autoreleaseFrequency: .inherit,
                                      target: nil)
    private var url: URL!
    private var data: Data?
    private var error: Error? = nil
    private var session = URLSession.shared
    
    // Initializer
    public convenience init(with url: URL) {
        self.init()
        self.url = url
    }
    // Operation Start
    override public func main() {
        NetworkActivityIndicator.shared.incrementActivityIndicator()
        if let data = FetchImage.cache.object(forKey: url.absoluteString as NSString) as? Data {
            self.data = data
            self.finish()
        } else {
            queue.async {
                self.session.dataTask(with: self.url) { (data, response, error) in
                    guard nil == error,
                        let data = data else {
                            self.error = error
                            self.finish()
                            return
                    }
                    self.data = data
                    let nsData: NSData = data as NSData
                    FetchImage.cache.setObject(nsData, forKey: self.url.absoluteString as NSString)
                    self.finish()
                }.resume()
            }
        }
    }
    // Operation Finish
    private func finish() {
        Log.error(with: #line, functionName: #function, error: error)
        self.fetchImageOperationCompletionBlock?(data)
        self.state(.finished)
        NetworkActivityIndicator.shared.decrementActivityIndicator()
    }
}
