//
//  NotesViewController+TableView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        noteCell.titleLabel.text = self.notes?[indexPath.row].title
        return noteCell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
        let noteHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: NotesHeaderCell.identifier) as! NotesHeaderCell
        return noteHeaderCell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow, let note = self.notes?[indexPath.row] else { return }
        onNoteSelected(note)
    }
    
}
