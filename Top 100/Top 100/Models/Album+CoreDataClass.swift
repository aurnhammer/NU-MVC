//
//  Album+CoreDataClass.swift
//  
//
//  Created by William Aurnhammerurnhammer on 1/8/19.
//
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case albumRank
        case id
        case artworkUrl100
        case name
        case artistName
        case url
        case releaseDate
    }

    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        // Create NSEntityDescription with NSManagedObjectContext
        guard let codingUserInfoKeyContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyContext] as? NSManagedObjectContext,
            let entityDescription = NSEntityDescription.entity(forEntityName: "Album", in: managedObjectContext) else {
                fatalError("Failed to decode Album!")
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)
        
        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let albumRank = decoder.codingPath[0].intValue else {
            throw JSONDecoder.SerializationError.missing("albumRank")
        }
        self.albumRank = Int16(albumRank)
        albumID = try values.decode(String.self, forKey: .id)
        albumArtworkURL = try? values.decode(URL.self, forKey: .artworkUrl100)
        albumName = try? values.decode(String.self, forKey: .name)
        artistName = try? values.decode(String.self, forKey: .artistName)
        itunesLink = try? values.decode(URL.self, forKey: .url)
        releaseDate = try? values.decode(String.self, forKey: .releaseDate)
    }

}
