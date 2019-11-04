//
//  DataManager.swift
//  Top 100
//
//  Created by William Aurnhammer on 3/29/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// A concrete class used to fetch data from a url
final class DataManager {
    
    private let session: URLSession
    
    // MARK: - Initializers
    
    /// Initialzer for the DataManager.
    ///
    /// - Parameters:
    ///     - session: Injects the URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// Fetch Data with the passed in URL.
    ///
    /// - Parameters:
    ///     - url: Injects the URL
    ///
    ///     - data: The Data, if any, returned from the Session
    ///     - response: The URLResponse, if any, returned from the Session
    ///     - error: The Error, if any, returned from the Session
    func fetchData(from url: URL, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        dataTask.resume()
    }
}
