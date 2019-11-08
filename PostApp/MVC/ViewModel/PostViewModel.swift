//
//  PostViewModel.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import Foundation
import UIKit

struct PostViewModel: Equatable, Hashable {
    
    let id: Int32
    let coverImageUrl: URL?
    let title: String?
    let medias: [Media]
    private let rawDetails: String
    
    lazy var details: NSAttributedString = {
        return NSAttributedString(string: rawDetails, attributes: [.font: UIFont.systemFont(ofSize: 16)]).highlighted(pattern: MatchingPattern.hashtagAndEmail, withFont: UIFont.boldSystemFont(ofSize: 16))
    }()
    
    // DI
    init(post: Post) {
        self.id = post.id
        self.coverImageUrl = post.medias.first{$0.isCover}?.coverUrl
        self.title = post.member?.username?.uppercased()
        self.medias = post.medias.sorted(by: >)
        self.rawDetails = post.details ?? ""
    }
    
    // Equitable
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
