//
//  PostTableViewCell.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var post: Post! {
        didSet {
            configureCell(withPost: post)
        }
    }
    
    func configureCell(withPost post: Post) {
        coverImageView.sd_setImage(with: post.coverImageUrl)
        avatarImageView.sd_setImage(with: post.member?.avatarUrl)
        titleLabel.text = post.title
        subtitleLabel.text = post.subtitle
    }
}
