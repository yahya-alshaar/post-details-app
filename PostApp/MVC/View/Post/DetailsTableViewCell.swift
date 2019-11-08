//
//  DetailsTableViewCell.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/8/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

@objc
protocol DetailsTableViewCellDelegate {
    func detailsTableViewCell(_ detailsTableViewCell: DetailsTableViewCell, shouldInteractWith URL: URL) -> Bool
}

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: ExpandableTextView!
    
    weak var delegate: DetailsTableViewCellDelegate?
    
    private func configureView() {
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.linkTextAttributes = linkAttributes
        textView.delegate = self
        
        let expandableTextAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.gray,
            .font: textView.font!.with([.traitBold, .traitItalic])

        ]
        
        textView.attributedExpandCaption = NSAttributedString(string: "... Read more", attributes: expandableTextAttributes)
        textView.attributedCollapseCaption = NSAttributedString(string: " Read less", attributes: expandableTextAttributes)
    }
    
    
    // MARK: - Reusability
    override func awakeFromNib() {
        super.awakeFromNib()
        clearView()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearView()
    }
    
    func clearView() {
        textView.attributedText = nil
    }
}

extension DetailsTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.detailsTableViewCell(self, shouldInteractWith: URL) ?? true
    }
}

