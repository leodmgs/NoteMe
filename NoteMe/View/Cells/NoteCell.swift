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
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -4)
            ])
    }
    
}
