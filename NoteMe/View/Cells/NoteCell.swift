//
//  NoteCell.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell {
    
    static let identifier = "com.leodmgs.NoteMe.NoteCell.identifier"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let categoryLabel: EdgeInsetLabel = {
        let label = EdgeInsetLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return label
    }()
    
    let updatedNoteLabel: EdgeInsetLabel = {
        let label = EdgeInsetLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = .smallTextAttributed(forText: "03/29/2019")
        return label
    }()
    
    var tags: [Tag]? {
        didSet {
            guard let tags = tags else { return }
            tagsLabel.attributedText = attributedTags(for: tags)
        }
    }
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupCellView() {
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(updatedNoteLabel)
        addSubview(tagsLabel)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 8),
            updatedNoteLabel.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 8),
            updatedNoteLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(
                equalTo: categoryLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(
                equalTo: categoryLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tagsLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 8)
            ])
    }
    
    private func attributedTags(for tags: [Tag]) -> NSMutableAttributedString {
        let attributedTags = NSMutableAttributedString()
        let availableWidth = UIScreen.main.bounds.width - 80
        var tagCounter = 0
        for tag in tags {
            if let name = tag.name {
                let attrString = NSAttributedString(
                    string: " \(name) ",
                    attributes: [.font : UIFont.systemFont(
                        ofSize: 11,
                        weight: UIFont.Weight.bold),
                                 .foregroundColor: UIColor.gray,
                                 .backgroundColor: UIColor.noteLightGray])
                if (attributedTags.size().width + attrString.size().width) > availableWidth {
                    attributedTags.append(
                        NSAttributedString(string: " +\(tags.count - tagCounter)",
                        attributes: [.font : UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold), .foregroundColor: UIColor.gray]))
                    break
                } else {
                    tagCounter += 1
                    attributedTags.append(attrString)
                    attributedTags.append(NSAttributedString(string: "  "))
                }
            }
        }
        return attributedTags
    }
    
}
