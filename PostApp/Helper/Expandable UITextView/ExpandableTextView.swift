//
//  ExpandableTextView.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/8/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

@IBDesignable
public class ExpandableTextView: UITextView {
    
    // MARK: - Configuration Properties
    
    @IBInspectable
    public var maximumLines: Int = 0 {
        didSet {
            _originalMaximumNumberOfLines = maximumLines
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var trimmable: Bool = false {
        didSet {
            guard trimmable != oldValue else { return }
            
            if trimmable {
                maximumLines = _originalMaximumNumberOfLines
            } else {
                let _maximumNumberOfLines = maximumLines
                maximumLines = 0
                _originalMaximumNumberOfLines = _maximumNumberOfLines
            }
            cachedIntrinsicContentHeight = nil
            setNeedsLayout()
        }
    }
    
    public var onSizeChange: (ExpandableTextView)->() = { _ in }
    public var expandedTextPadding: UIEdgeInsets
    public var collapsedTextPadding: UIEdgeInsets
    
    // MARK: - Captions
    
    public var expandCaption: String? {
        get {
            return attributedExpandCaption?.string
        }
        set {
            if let text = newValue {
                attributedExpandCaption = attributedStringWithDefaultAttributes(from: text)
            } else {
                attributedExpandCaption = nil
            }
        }
    }
    
    public var collapseCaption: String? {
        get {
            return attributedCollapseCaption?.string
        }
        set {
            if let text = newValue {
                attributedCollapseCaption = attributedStringWithDefaultAttributes(from: text)
            } else {
                attributedCollapseCaption = nil
            }
        }
    }
    
    public var attributedExpandCaption: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    public var attributedCollapseCaption: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: - Initialization
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        expandedTextPadding = .zero
        collapsedTextPadding = .zero
        super.init(frame: frame, textContainer: textContainer)
        configurePreferences()
    }
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        expandedTextPadding = .zero
        collapsedTextPadding = .zero
        super.init(coder: aDecoder)
        configurePreferences()
    }
    
    private func configurePreferences() {
        let defaultReadMoreText = NSLocalizedString("ExpandableTextView.readMore", value: "more", comment: "")
        let attributedReadMoreText = NSMutableAttributedString(string: "... ")
        
        expandedTextPadding = .zero
        collapsedTextPadding = .zero
        isScrollEnabled = false
        isEditable = false
        
        let attributedDefaultReadMoreText = NSAttributedString(string: defaultReadMoreText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)
        ])
        attributedReadMoreText.append(attributedDefaultReadMoreText)
        self.attributedExpandCaption = attributedReadMoreText
    }
    
    public func setNeedsUpdateTrim() {
        _needsUpdateTrim = true
        setNeedsLayout()
    }
    
    
    public override var text: String! {
        didSet {
            if let text = text {
                _originalAttributedText = attributedStringWithDefaultAttributes(from: text)
            } else {
                _originalAttributedText = nil
            }
        }
    }
    
    public override var attributedText: NSAttributedString! {
        willSet {
            if #available(iOS 9.0, *) { return }
            //on iOS 8 text view should be selectable to properly set attributed text
            if newValue != nil {
                isSelectable = true
            }
        }
        didSet {
            _originalAttributedText = attributedText
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if _needsUpdateTrim {
            //reset text to force update trim
            attributedText = _originalAttributedText
            _needsUpdateTrim = false
        }
        needsTrim() ? collapseText() : expandText()
    }
    
    public override var intrinsicContentSize : CGSize {
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        var intrinsicContentSize = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer).size
        intrinsicContentSize.width = UIView.noIntrinsicMetric
        intrinsicContentSize.height += (textContainerInset.top + textContainerInset.bottom)
        intrinsicContentSize.height = ceil(intrinsicContentSize.height)
        return intrinsicContentSize
    }
    
    private var intrinsicContentHeight: CGFloat {
        return intrinsicContentSize.height
    }
    
    private var cachedIntrinsicContentHeight: CGFloat?
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return hitTest(pointInGliphRange: point, event: event) { _ in
            guard shouldInteractWithPoint(point) != nil else { return nil }
            return self
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            trimmable = shouldInteractWithPoint(point) ?? trimmable
        }
        super.touchesEnded(touches, with: event)
    }
    
    //MARK: Private methods
    
    private var _needsUpdateTrim = false
    private var _originalMaximumNumberOfLines: Int = 0
    private var _originalAttributedText: NSAttributedString!
    private var _originalTextLength: Int {
        get {
            return _originalAttributedText?.string.length ?? 0
        }
    }
    
    private func attributedStringWithDefaultAttributes(from text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: textColor ?? UIColor.black
        ])
    }
    
    private func needsTrim() -> Bool {
        return trimmable && expandCaption != nil
    }
    
    private func invokeOnSizeChangeIfNeeded() {
        if let cachedIntrinsicContentHeight = cachedIntrinsicContentHeight {
            if intrinsicContentHeight != cachedIntrinsicContentHeight {
                self.cachedIntrinsicContentHeight = intrinsicContentHeight
                onSizeChange(self)
            }
        } else {
            self.cachedIntrinsicContentHeight = intrinsicContentHeight
            onSizeChange(self)
        }
    }
    
    private func shouldInteractWithPoint(_ point: CGPoint) -> Bool? {
        if needsTrim() && pointIsInTextRange(point: point, range: rangeOfExpandedText(), padding: expandedTextPadding) {
            return false
        } else if collapseCaption != nil && pointIsInTextRange(point: point, range: rangeOfCollapsedText(), padding: collapsedTextPadding) {
            return true
        }
        return nil
    }
}

// MARK: - Text Trimming
extension ExpandableTextView {
    
    
    private func collapseText() {
        if let expandedText = expandCaption, text.hasSuffix(expandedText) { return }
        
        trimmable = true
        textContainer.maximumNumberOfLines = maximumLines
        
        layoutManager.invalidateLayout(forCharacterRange: layoutManager.rangOfFittedCharactersInContainer( textContainer), actualCharacterRange: nil)
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        
        if let text = attributedExpandCaption {
            let range = rangeToReplaceWithExpandedText()
            guard range.location != NSNotFound else { return }
            
            textStorage.replaceCharacters(in: range, with: text)
        }
        
        invalidateIntrinsicContentSize()
        invokeOnSizeChangeIfNeeded()
    }
    
    private func expandText() {
        if let readLessText = collapseCaption, text.hasSuffix(readLessText) { return }
        
        trimmable = false
        textContainer.maximumNumberOfLines = 0
        
        if let originalAttributedText = _originalAttributedText?.mutableCopy() as? NSMutableAttributedString {
            attributedText = _originalAttributedText
            let range = NSRange(location: 0, length: text.length)
            if let attributedReadLessText = attributedCollapseCaption {
                originalAttributedText.append(attributedReadLessText)
            }
            textStorage.replaceCharacters(in: range, with: originalAttributedText)
        }
        
        invalidateIntrinsicContentSize()
        invokeOnSizeChangeIfNeeded()
    }
    
    private func characterIndexBeforeTrim(range rangeThatFits: NSRange) -> Int {
        if let text = attributedExpandCaption {
            let readMoreBoundingRect = boundingRectForAttributedExpandedText(text, boundingRectThatFits: textContainer.size)
            let lastCharacterRect = layoutManager.boundingRectForCharacterRange( NSMakeRange(NSMaxRange(rangeThatFits)-1, 1), inTextContainer: textContainer)
            var point = lastCharacterRect.origin
            point.x = textContainer.size.width - ceil(readMoreBoundingRect.size.width)
            let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            return characterIndex - 1
        } else {
            return NSMaxRange(rangeThatFits) - expandCaption!.length
        }
    }
    
    private func boundingRectForAttributedExpandedText(_ text: NSAttributedString, boundingRectThatFits size: CGSize) -> CGRect {
        let textContainer = NSTextContainer(size: size)
        let textStorage = NSTextStorage(attributedString: text)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let readMoreBoundingRect = layoutManager.boundingRectForCharacterRange( NSMakeRange(0, text.length), inTextContainer: textContainer)
        return readMoreBoundingRect
    }
}


// MARK: - Range Definition
extension ExpandableTextView {
    
    
    private func rangeOfExpandedText() -> NSRange {
        var readMoreTextRange = rangeToReplaceWithExpandedText()
        if readMoreTextRange.location != NSNotFound {
            readMoreTextRange.length = expandCaption!.length + 1
        }
        return readMoreTextRange
    }
    
    private func rangeOfCollapsedText() -> NSRange {
        return NSRange(location: _originalTextLength, length: collapseCaption!.length + 1)
    }
    
    private func rangeToReplaceWithExpandedText() -> NSRange {
        let rangeThatFitsContainer = layoutManager.rangOfFittedCharactersInContainer( textContainer)
        if NSMaxRange(rangeThatFitsContainer) == _originalTextLength {
            return NSMakeRange(NSNotFound, 0)
        }
        else {
            let lastCharacterIndex = characterIndexBeforeTrim(range: rangeThatFitsContainer)
            if lastCharacterIndex > 0 {
                return NSMakeRange(lastCharacterIndex, textStorage.string.length - lastCharacterIndex)
            }
            else {
                return NSMakeRange(NSNotFound, 0)
            }
        }
    }
}

// MARK: - Hit Test
extension UITextView {
    
    
    public func hitTest(pointInGliphRange point: CGPoint, event: UIEvent?, test: (Int) -> UIView?) -> UIView? {
        guard let charIndex = indexForCharacterInPoint(point) else {
            return super.hitTest(point, with: event)
        }
        guard textStorage.attribute(NSAttributedString.Key.link, at: charIndex, effectiveRange: nil) == nil else {
            return super.hitTest(point, with: event)
        }
        return test(charIndex)
    }
    
    public func pointIsInTextRange(point aPoint: CGPoint, range: NSRange, padding: UIEdgeInsets) -> Bool {
        var boundingRect = layoutManager.boundingRectForCharacterRange( range, inTextContainer: textContainer)
        boundingRect = boundingRect.offsetBy(dx: textContainerInset.left, dy: textContainerInset.top)
        boundingRect = boundingRect.insetBy(dx: -(padding.left + padding.right), dy: -(padding.top + padding.bottom))
        return boundingRect.contains(aPoint)
    }
    
    public func indexForCharacterInPoint(_ point: CGPoint) -> Int? {
        let point = CGPoint(x: point.x, y: point.y - textContainerInset.top)
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSMakeRange(glyphIndex, 1), in: textContainer)
        if glyphRect.contains(point) {
            return layoutManager.characterIndexForGlyph(at: glyphIndex)
        } else {
            return nil
        }
    }
    
}
