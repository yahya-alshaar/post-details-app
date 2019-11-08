//
//  Media+CoreDataProperties.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//
//

import Foundation
import CoreData


extension Media {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }
    
    @NSManaged public var coverUrl: URL?
    @NSManaged public var id: Int32
    @NSManaged public var isCover: Bool
    @NSManaged public var url: URL?
    @NSManaged public var post: Post?
    
}
