//
//  NSAttributedString + Highlighted.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func highlighted(pattern: String, withFont font: UIFont) -> NSAttributedString {
        let baseAttributed = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: string.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return self
        }
        
        regex
            .matches(in: string, options: .withTransparentBounds, range: range)
            .forEach { baseAttributed
                .addAttributes([NSAttributedString.Key.font: font,
                                NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.link: "smartGuysMakeGoodCodePractices"],
                               range: $0.range) }
        
        return baseAttributed
    }
}
