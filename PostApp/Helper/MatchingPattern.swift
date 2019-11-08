//
//  MatchingPattern.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import Foundation

struct MatchingPattern {
    static let hashtagAndEmail = ##"\B([\#|@][a-zA-Z-0-9]+\b)(?!;)"##
}
