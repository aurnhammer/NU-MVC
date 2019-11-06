//
//  Movie.swift
//  Top 100
//
//  Created by William Aurnhammer on 11/4/19.
//  Copyright © 2019 iHeart Media Inc. All rights reserved.
//

import UIKit

struct Movie: Codable {
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

