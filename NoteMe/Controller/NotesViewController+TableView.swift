//
//  NotesViewController+TableView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        configure(noteCell, at: indexPath)
        return noteCell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
        let noteHeaderCell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NotesHeaderCell.identifier) as! NotesHeaderCell
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
        if indexPath.section == 0 {
            if let sections = fetchedResultsController.sections,
                let notesObject = sections[indexPath.section].objects as? [Note] {
                if let title = notesObject[indexPath.item].title {
                    let titleHeightSize =
                        estimatedBoundingTextViewSize(text: title).height
                    let totalConstraintsOffset: CGFloat = 110
                    return titleHeightSize + totalConstraintsOffset
                }
            }
        }
        return 40
    }
    
    func estimatedBoundingTextViewSize(text: String, offset: CGFloat = 0) -> CGSize {
        let textViewFrameWidth = view.frame.width - 82
        let textViewFrameSize = CGSize(width: textViewFrameWidth, height: 1000)
        let fontAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)]
        let boundingSize = NSString(string: text).boundingRect(with: textViewFrameSize, options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
        return CGSize(width: textViewFrameWidth, height: boundingSize.height + offset)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        onNoteSelected(note)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultsController.object(at: indexPath)
            coreDataBroker.managedObjectContext.delete(note)
            notes?.remove(at: indexPath.row)
        }
    }
    
}
