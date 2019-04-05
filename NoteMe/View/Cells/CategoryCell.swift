//
//  CategoryCell.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/21/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UITableViewCell {
    
    static let identifier = "com.leodmgs.NoteMe.CategoryCell.identifier"
    
    var categoryColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.backgroundColor = CategoryColor.blue
        view.clipsToBounds = true
        return view
    }()
    
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
        backgroundColor = .white
        addSubview(categoryColor)
        addSubview(titleLabel)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            categoryColor.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryColor.leadingAnchor.constraint(
                equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
            categoryColor.heightAnchor.constraint(equalToConstant: 28),
            categoryColor.widthAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: categoryColor.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
}
