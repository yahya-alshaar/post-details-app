//
//  Media+CoreDataClass.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Media)
public class Media: NSManagedObject, Codable {
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext
            else {
                fatalError("Failed to decode Media")
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var entityName: String
        if try container.decodeIfPresent(Bool.self, forKey: .isVideo) ?? false {
            entityName = "Video"
        }else {
            entityName = "Image"
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {
            fatalError("Failed to decode Media")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.isCover = try container.decode(Bool.self, forKey: .isCover)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.coverUrl = try container.decodeIfPresent(URL.self, forKey: .coverUrl)
        
        if entityName == "Video" {
            setValue(try container.decode(Double.self, forKey: .videoLength), forKey: "length")
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isCover, forKey: .isCover)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(coverUrl, forKey: .coverUrl)
        
        switch self {
        case let video as Video:
            try container.encode(video.length, forKey: .videoLength)
        default:
            break
        }
    }
    
    var isVideo: Bool {
        return isKind(of: Video.self)
    }
}

extension Media: Comparable {
    
    public static func < (lhs: Media, rhs: Media) -> Bool {
        lhs.id < rhs.id
    }
}

extension Media /* +Coding Key **/ {
    enum CodingKeys: String, CodingKey {
        case id
        case url = "media"
        case isCover = "is_cover"
        case coverUrl = "cover_image"
        case videoLength = "video_length"
        case isVideo = "is_video"
    }
}

