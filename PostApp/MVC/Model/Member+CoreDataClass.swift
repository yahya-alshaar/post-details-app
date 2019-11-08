//
//  Member+CoreDataClass.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Member)
public class Member: NSManagedObject, Codable {
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Member", in: managedObjectContext) else {
                fatalError("Failed to decode Member")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.avatarUrl = try container.decodeIfPresent(URL.self, forKey: .avatar)
        self.username = try container.decode(String.self, forKey: .username)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(avatarUrl, forKey: .avatar)
        try container.encodeIfPresent(username, forKey: .username)
        
    }
}

extension Member /* +Coding Keys **/ {
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatar = "resized_avatar"
        
    }
}

