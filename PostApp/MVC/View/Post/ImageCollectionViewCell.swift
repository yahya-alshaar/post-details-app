//
//  ImageCollectionViewCell.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit
import SwiftUI


class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: Image! {
        didSet {
            imageView.sd_setImage(with: image.url)
        }
    }
    
    class var identifier: String {
        return "ImageCell"
    }
}
