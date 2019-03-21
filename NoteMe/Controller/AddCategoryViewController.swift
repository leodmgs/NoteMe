//
//  AddCategoryViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/19/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    let categoryView: CategoryView = {
        let categoryView = CategoryView()
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        return categoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(categoryView)
        activateRegularConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "New Category"
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
        saveCategory()
        popViewController()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            categoryView.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor),
            categoryView.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor),
            categoryView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor)
            ])
    }
    
    private func saveCategory() {
        guard let managedObjectContext = managedObjectContext else { return }
        let category = Category(context: managedObjectContext)
        category.name = categoryView.nameTextField.text
        category.colorId = Int16(categoryView.selectedColorId)
    }
    
}
