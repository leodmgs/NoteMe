//
//  AddTagViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 4/2/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol AddTagViewControllerDelegate {
    func didTagListUpdated(for tags: [Tag])
}

class AddTagViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    var delegate: AddTagViewControllerDelegate?
    var tags: [Tag] = []
    
    let addTagView: AddTagView = {
        let view = AddTagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        addTagView.tagsTableView.delegate = self
        addTagView.tagsTableView.dataSource = self
        addTagView.tagsTableView.register(
            TagCell.self, forCellReuseIdentifier: TagCell.identifier)
        addTagView.addTagButton.addTarget(
            self, action: #selector(onAddTag), for: .touchUpInside)
        view.addSubview(addTagView)
        activateRegularConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Tags"
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
        if let delegate = delegate {
            delegate.didTagListUpdated(for: tags)
        }
        popViewController()
    }
    
    @objc private func onAddTag() {
        guard let tagName = addTagView.tagTitle.text,
            let manageObjectContext = managedObjectContext else { return }
        let tag = Tag(context: manageObjectContext)
        
        // trimmingCharacters function remove all leading and trailing space
        // charactes
        var nameFormatted = tagName.lowercased().trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines)
        if !nameFormatted.starts(with: "#") {
            nameFormatted = "#\(nameFormatted)"
        }
        tag.name = nameFormatted
        tags.append(tag)
        DispatchQueue.main.async {
            self.addTagView.tagsTableView.reloadData()
        }
        addTagView.tagTitle.text = ""
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            addTagView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            addTagView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            addTagView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor),
            addTagView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            ])
    }
    
}


extension AddTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagCell = tableView.dequeueReusableCell(
            withIdentifier: TagCell.identifier) as! TagCell
        tagCell.tagName.text = tags[indexPath.item].name
        return tagCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tags.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
