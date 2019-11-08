//
//  Post+CoreDataClass.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject, Codable {
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedObjectContext) else {
                fatalError("Failed to decode Post")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.details = try container.decodeIfPresent(String.self, forKey: .details)
        self.medias = try container.decode(Set<Media>.self, forKey: .medias)
        self.member = try container.decodeIfPresent(Member.self, forKey: .member)
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(medias, forKey: .medias)
        try container.encodeIfPresent(details, forKey: .details)
        try container.encodeIfPresent(member, forKey: .member)
    }
    
    //MARK: - Displayed
    var coverImageUrl: URL? {
        return medias.first{$0.isCover}?.coverUrl
    }
    
    var title: String {
        var substring = Substring()
        
        if let username = member?.username?.uppercased() {
            substring.append(contentsOf: username)
        }
        
        return String(substring)
    }
    
    var subtitle: String {
        var substring = Substring()
        
        if let createdAt = createdAt {
            let displayed = dateFormatter.string(from: createdAt)
            substring.append(contentsOf: displayed)
        }
        return String(substring)
    }
}

extension Post /* +Coding Keys **/ {
    enum CodingKeys: String, CodingKey {
        case id
        case member
        case details = "description"
        case createdAt = "created_at"
        case medias = "post_medias"
    }
}
