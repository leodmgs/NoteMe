//
//  NotesView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class UINotesView: UIView {
    
    let notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        notesTableView.register(
            NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
        notesTableView.register(
            NotesHeaderCell.self, forHeaderFooterViewReuseIdentifier: NotesHeaderCell.identifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been initialized")
    }
    
    private func setupView() {
        addSubview(notesTableView)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            notesTableView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 20),
            notesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            notesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}
