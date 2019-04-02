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
    func didTagListUpdated(for tags: [String])
}

class AddTagViewController: UIViewController {
    
    var delegate: AddTagViewControllerDelegate?
    var tags: [String]?
    
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
        print("Cancel")
        popViewController()
    }
    
    private func popViewController() {
        if let delegate = delegate, let tagList = tags {
            delegate.didTagListUpdated(for: tagList)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onSaveTapped() {
        popViewController()
    }
    
    @objc private func onAddTag() {
        guard let tagName = addTagView.tagTitle.text else { return }
        tags?.append(tagName)
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
        guard let tags = tags else { return 0 }
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagCell = tableView.dequeueReusableCell(
            withIdentifier: TagCell.identifier) as! TagCell
        tagCell.tagName.text = tags?[indexPath.item]
        return tagCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tags?.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}


class TagCell: UITableViewCell {
    
    static let identifier = "com.leodmgs.NoteMe.TagCell.identifier"
    
    let tagName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViewCell() {
        backgroundColor = .white
        addSubview(tagName)
        activateRegularConstraints()
    }
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            tagName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
}
