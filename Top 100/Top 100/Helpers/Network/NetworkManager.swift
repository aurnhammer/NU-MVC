//
//  NetworkManager.swift
//  Top 30
//
//  Created by William Aurnhammerurnhammer on 1/15/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import UIKit

/// A DataLoadable
protocol NetworkDataLoadable {
    
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkDataLoadable {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}

final class NetworkManager {
    
    private let session: NetworkDataLoadable
    
    init(session: NetworkDataLoadable = URLSession.shared) {
        self.session = session
    }
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.loadData(from: url) { data, response, error in
            completionHandler(data, response, error)
        }
    }
}
