//
//  AddNoteViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/14/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class AddNoteViewController: UIViewController {
    
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
        let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onBackTapped))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func onBackTapped() {
        _ = navigationController?.popViewController(animated: true)
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
