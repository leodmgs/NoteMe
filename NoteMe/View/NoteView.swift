//
//  NoteView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/15/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class NoteView: UIView {
    
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
        textView.backgroundColor = .noteLightGray
        textView.text = "Write something here!"
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupView() {
        titleTextField.addSubview(bottomLine)
        addSubview(titleTextField)
        addSubview(contentsTextView)
        activateRegularConstraints()
    }
    
    func showAlertForNote(
        title: String,
        message: String,
        options: [UIAlertAction]?) -> UIAlertController? {
        
        guard let _ = options else {
            /* In case that any options is defined, a simple alert is displayed
            presenting a single option, "OK". The action after this event
            needs to be handled by the caller. */
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alert
        }
        // TODO: handle alert with options
        return nil
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 28),
            titleTextField.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -8),
            
            bottomLine.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 2),
            bottomLine.leadingAnchor.constraint(
                equalTo: titleTextField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(
                equalTo: titleTextField.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            contentsTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 20),
            contentsTextView.leadingAnchor.constraint(
                equalTo: titleTextField.leadingAnchor),
            contentsTextView.trailingAnchor.constraint(
                equalTo: titleTextField.trailingAnchor),
            contentsTextView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -28)
            ])
    }
}
