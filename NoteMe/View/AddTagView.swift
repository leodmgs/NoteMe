//
//  AddTagView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 4/2/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class AddTagView: UIView {
    
    let tagTitle: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tag name"
        return textField
    }()
    
    let textFieldBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let addTagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.noteBlue, for: .normal)
        return button
    }()
    
    let tagsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        tagTitle.addSubview(textFieldBottomLine)
        addSubview(tagTitle)
        addSubview(addTagButton)
        addSubview(tagsTableView)
        setupRegularConstraints()
    }
    
    private func setupRegularConstraints() {
        NSLayoutConstraint.activate([
            tagTitle.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 28),
            tagTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagTitle.trailingAnchor.constraint(
                equalTo: addTagButton.leadingAnchor, constant: -8),
            
            textFieldBottomLine.topAnchor.constraint(
                equalTo: tagTitle.bottomAnchor, constant: 2),
            textFieldBottomLine.leadingAnchor.constraint(
                equalTo: tagTitle.leadingAnchor),
            textFieldBottomLine.trailingAnchor.constraint(
                equalTo: tagTitle.trailingAnchor),
            textFieldBottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            addTagButton.centerYAnchor.constraint(equalTo: tagTitle.centerYAnchor),
            addTagButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            addTagButton.widthAnchor.constraint(equalToConstant: 50),
            addTagButton.heightAnchor.constraint(equalToConstant: 30),
            
            tagsTableView.topAnchor.constraint(
                equalTo: tagTitle.bottomAnchor, constant: 12),
            tagsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagsTableView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -8),
            tagsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
            ])
    }
    
}
