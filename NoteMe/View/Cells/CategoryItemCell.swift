//
//  CategoryItemCell.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/29/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemCell: UICollectionViewCell {
    
    static let identifier: String = "com.leodmgs.NoteMe.CategoryItemCell.identifier"
    
    let itemName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
        layer.cornerRadius = 3
        clipsToBounds = true
        addSubview(itemName)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            itemName.topAnchor.constraint(equalTo: self.topAnchor),
            itemName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
}
