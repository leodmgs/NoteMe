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
    
    var managedObjectContext: NSManagedObjectContext?
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        return textField
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Write something here!"
        textView.textColor = .lightGray
        return textView
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
        titleTextField.addSubview(bottomLine)
        view.addSubview(titleTextField)
        view.addSubview(contentsTextView)
        contentsTextView.delegate = self
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor, constant: 28),
            titleTextField.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            
            bottomLine.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor),
            bottomLine.leadingAnchor.constraint(
                equalTo: titleTextField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(
                equalTo: titleTextField.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.2),
            
            contentsTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 20),
            contentsTextView.leadingAnchor.constraint(
                equalTo: titleTextField.leadingAnchor),
            contentsTextView.trailingAnchor.constraint(
                equalTo: titleTextField.trailingAnchor),
            contentsTextView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
            ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Note"
        let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveTapped))
        let discardButtonItem = UIBarButtonItem(title: "Discard", style: .plain, target: self, action: #selector(onDiscardChangesTapped))
        navigationItem.leftBarButtonItem = saveButtonItem
        navigationItem.rightBarButtonItem = discardButtonItem
    }
    
    @objc private func onDiscardChangesTapped() {
        popViewController()
    }
    
    private func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onSaveTapped() {
        saveChanges()
        popViewController()
    }
    
    private func saveChanges() {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let noteTitle = titleTextField.text, !noteTitle.isEmpty else {
            showAlert(
                title: "Title missing!",
                message: "You need to fill in a title for this note.")
            return
        }
        let note = Note(context: managedObjectContext)
        note.title = noteTitle
        note.createdAt = Date()
        note.updatedAt = Date()
        note.contents = contentsTextView.text
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
