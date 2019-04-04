//
//  TagCell.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 4/4/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UITableViewCell {
    
    static let identifier = "com.leodmgs.NoteMe.TagCell.identifier"
    
    let tagName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViewCell() {
        backgroundColor = .white
        addSubview(tagName)
        activateRegularConstraints()
    }
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            tagName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
}
