//
//  NSLayoutManager + TextContainer.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/8/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

extension NSLayoutManager {
    
    public func rangOfFittedCharactersInContainer(_ container: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRange(for: container)
        rangeThatFits = self.characterRange(forGlyphRange: rangeThatFits, actualGlyphRange: nil)
        
        return rangeThatFits
    }
    
    public func boundingRectForCharacterRange(_ range: NSRange, inTextContainer container: NSTextContainer) -> CGRect {
        let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
        
        return boundingRect
    }
    
}
