//
//  CodingUserInfoKey + Core Data Context.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import Foundation

public extension CodingUserInfoKey {
    // Helper property to retrieve the context of Core Data
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
