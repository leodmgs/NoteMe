//
//  AddNoteViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/14/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    /*
     The instance of the managed object context is required in order to create
     a Note object that will be managed by its context. The reference for this
     object needs to be assigned before calling this class.
     */
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
    }
    
    private func setupView() {
        setupNavigationBar()
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
        view.addSubview(noteView)
        activateRegularConstraints()
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
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Note"
        let saveButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(onSaveTapped))
        let discardButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(onCancelTapped))
        navigationItem.rightBarButtonItem = saveButtonItem
        navigationItem.leftBarButtonItem = discardButtonItem
    }
    
    @objc private func onCancelTapped() {
        popViewController()
    }
    
    private func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onSaveTapped() {
        saveNote()
        popViewController()
    }
    
    private func saveNote() {
        /*
         Unwrap the managed object context property to make sure that it has
         been created and assigned properly for this class.
         */
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
        /*
         The Note object is created in the managed object context and its
         properties are configured.
         */
        let note = Note(context: managedObjectContext)
        note.title = noteTitle
        note.createdAt = Date()
        note.updatedAt = Date()
        note.contents = noteView.contentsTextView.text
    }
    
}

extension AddNoteViewController: UITextViewDelegate {
    
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
