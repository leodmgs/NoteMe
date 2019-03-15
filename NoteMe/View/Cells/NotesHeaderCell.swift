//
//  NotesHeaderCell.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class NotesHeaderCell: UITableViewHeaderFooterView {
    
    static let identifier = "com.leodmgs.NoteMe.NotesHeaderCell.identifier"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "Notes"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderCellView() {
        contentView.backgroundColor = .white
        addSubview(titleLabel)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 20)
            ])
    }
    
}
