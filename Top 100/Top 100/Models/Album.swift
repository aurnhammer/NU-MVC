//
//  Album.swift
//  Top 100
//
//  Created by William Aurnhammer on 10/30/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import Foundation
import UIKit

struct Album: Codable {
    var artworkUrl100: URL?
    var artworkThumbnailData: Data?
    var artworkThumbnailImage: UIImage? {
        guard let artworkThumbnailData = artworkThumbnailData else { return nil }
        return UIImage(data: artworkThumbnailData)
    }
    var name: String?
    var artistName: String?
    var url: URL?
    var releaseDate: String?
}
