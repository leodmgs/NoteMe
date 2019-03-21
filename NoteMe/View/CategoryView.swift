//
//  UICategoryView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/19/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class CategoryView: UIView {
    
    var selectedColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CategoryColor.blue
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    var selectedColorId: Int = CategoryColor.Id.blue
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Category name"
        return textField
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let categoryColorView: CategoryColorView = {
        let categoryColorView = CategoryColorView()
        categoryColorView.translatesAutoresizingMaskIntoConstraints = false
        return categoryColorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryColorView.delegate = self
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been initialized")
    }
    
    private func setupView() {
        nameTextField.addSubview(bottomLine)
        addSubview(selectedColor)
        addSubview(nameTextField)
        addSubview(categoryColorView)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            selectedColor.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 38),
            selectedColor.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 8),
            selectedColor.heightAnchor.constraint(equalToConstant: 28),
            selectedColor.widthAnchor.constraint(equalToConstant: 28),
            
            nameTextField.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(
                equalTo: selectedColor.trailingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -8),
            
            bottomLine.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor, constant: 2),
            bottomLine.leadingAnchor.constraint(
                equalTo: nameTextField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(
                equalTo: nameTextField.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            categoryColorView.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor, constant: 40),
            categoryColorView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 8),
            categoryColorView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -8),
            categoryColorView.heightAnchor.constraint(equalToConstant: 56)
            
            ])
    }
    
}

extension CategoryView: CategoryColorViewDelegate {
    func categoryColorDidSelected(color: UIColor, colorId: Int) {
        selectedColorId = colorId
        selectedColor.backgroundColor = color
    }
}
