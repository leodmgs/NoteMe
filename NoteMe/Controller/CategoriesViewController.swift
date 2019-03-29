//
//  CategoriesViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/19/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    // MARK: Unused
    var categories: [Category]?
    
    var managedObjectContext: NSManagedObjectContext?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: #keyPath(Category.name), ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        fetchCategories()
    }
    
    private func fetchCategories() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Fetch Categories")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        categoriesTableView.register(
            CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView()
        categoriesTableView.separatorStyle = .none
        view.addSubview(categoriesTableView)
        setupRegularConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Categories"
        let addButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddTapped))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc func onAddTapped() {
        guard let navController = navigationController else { return }
        guard let managedObjectContext = managedObjectContext else { return }
        let addCategoryViewController = AddCategoryViewController()
        addCategoryViewController.managedObjectContext = managedObjectContext
        navController.pushViewController(addCategoryViewController, animated: true)
    }
    
    private func setupRegularConstraints() {
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            categoriesTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            categoriesTableView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100),
            categoriesTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
            ])
    }
    
    func configure(_ cell: CategoryCell, at indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = category.name
        cell.categoryColor.backgroundColor =
            CategoryColor.getColor(id: Int(category.colorId))
    }
}


extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoriesTableView.endUpdates()
    }
    
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoriesTableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                categoriesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .insert:
            if let indexPath = newIndexPath {
                categoriesTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath,
                let cell = categoriesTableView.cellForRow(
                    at: indexPath) as? CategoryCell{
                configure(cell, at: indexPath)
            }
        default:
            print("Option not supported: \(type)")
        }
    }
}


extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        guard let currentSection =
            fetchedResultsController.sections?[section] else {
                return 0
        }
        return currentSection.numberOfObjects
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath) as! CategoryCell
        configure(categoryCell, at: indexPath)
        return categoryCell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}


