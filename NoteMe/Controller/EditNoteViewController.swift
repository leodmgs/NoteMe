//
//  EditNoteViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditNoteViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    lazy var noteView: NoteView = {
        let view = NoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentsTextView.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Edit Note"
        let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveChangesTapped))
        let discardButtonItem = UIBarButtonItem(title: "Discard", style: .plain, target: self, action: #selector(onDiscardChangesTapped))
        navigationItem.leftBarButtonItem = saveButtonItem
        navigationItem.rightBarButtonItem = discardButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(noteView)
        activateRegularConstraints()
    }
    
    @objc private func onDiscardChangesTapped() {
        popViewController()
    }
    
    private func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onSaveChangesTapped() {
        saveChanges()
        popViewController()
    }
    
    private func saveChanges() {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let noteTitle = noteView.titleTextField.text, !noteTitle.isEmpty else {
            let alert = noteView.showAlertForNote(
                title: "Title missing!",
                message: "You need to fill in a title for this note.",
                options: nil)
            if let alert = alert {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        let note = Note(context: managedObjectContext)
        note.title = noteTitle
        note.createdAt = Date()
        note.updatedAt = Date()
        note.contents = noteView.contentsTextView.text
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            noteView.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor),
            noteView.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor),
            noteView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor)
            ])
    }
    
}

extension EditNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.lowercased() == "write something here!" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write something here!"
            textView.textColor = .lightGray
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
}
