//
//  Post+CoreDataProperties.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var details: String?
    @NSManaged public var id: Int32
    @NSManaged public var medias: Set<Media>
    @NSManaged public var member: Member?

}

// MARK: Generated accessors for medias
extension Post {

    @objc(addMediasObject:)
    @NSManaged public func addToMedias(_ value: Media)

    @objc(removeMediasObject:)
    @NSManaged public func removeFromMedias(_ value: Media)

    @objc(addMedias:)
    @NSManaged public func addToMedias(_ values: NSSet)

    @objc(removeMedias:)
    @NSManaged public func removeFromMedias(_ values: NSSet)

}
