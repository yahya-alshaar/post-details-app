//
//  UIFont + Traits.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/8/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

extension UIFont {
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}

