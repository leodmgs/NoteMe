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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: #keyPath(Category.name), ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = nil
        return fetchedResultsController
    }()
    
    var note: Note? {
        didSet {
            guard let noteObject = note else { return }
            noteView.titleTextField.text = noteObject.title
            if let contents = noteObject.contents {
                if contents.count > 0 {
                    noteView.contentsTextView.textColor = .black
                }
                noteView.contentsTextView.text = contents
            }
            if let tags = noteObject.tags?.allObjects as? [Tag] {
                self.tags = tags
                DispatchQueue.main.async {
                    self.noteView.setAttributedTags(for: tags)
                }
            }
        }
    }
    
    var tags: [Tag]?
    var categoriesDatasource: [Category]?
    var selectedCategory: SelectedCategory?
    
    lazy var noteView: NoteView = {
        let view = NoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentsTextView.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.categoryCollection.delegate = self
        noteView.categoryCollection.dataSource = self
        noteView.categoryCollection.register(
            CategoryItemCell.self,
            forCellWithReuseIdentifier: CategoryItemCell.identifier)
        noteView.searchCategoryTextField.delegate = self
        fetchCategories()
        setupView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Edit Note"
        let saveButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(onSaveChangesTapped))
        let discardButtonItem = UIBarButtonItem(
            title: "Discard",
            style: .plain,
            target: self,
            action: #selector(onDiscardChangesTapped))
        navigationItem.rightBarButtonItem = saveButtonItem
        navigationItem.leftBarButtonItem = discardButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(noteView)
        noteView.addTagButton.addTarget(
            self,
            action: #selector(onAddTagTapped),
            for: .touchUpInside)
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
    
    @objc private func onAddTagTapped() {
        guard let navController = navigationController else { return }
        let addTagViewController = AddTagViewController()
        addTagViewController.managedObjectContext = self.managedObjectContext
        if let tags = tags {
            addTagViewController.tags = tags
        }
        addTagViewController.delegate = self
        navController.pushViewController(addTagViewController, animated: true)
    }
    
    private func saveChanges() {
        guard let noteTitle = noteView.titleTextField.text,
            !noteTitle.isEmpty else {
            let alert = noteView.showAlertForNote(
                title: "Title missing!",
                message: "You need to provide a title for this note.",
                options: nil)
            if let alert = alert {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        note?.title = noteTitle
        note?.updatedAt = Date()
        if let selected = selectedCategory {
            note?.category = selected.category
        }
        if let tags = tags {
            note?.tags = NSSet(array: tags)
        }
        note?.contents = noteView.contentsTextView.text
        
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
    
    private func fetchCategories() {
        do {
            try fetchedResultsController.performFetch()
            if let objects = fetchedResultsController.fetchedObjects {
                categoriesDatasource = objects
            }
        } catch {
            print("Unable to Fetch Categories")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
}

extension EditNoteViewController: AddTagViewControllerDelegate {
    
    func didTagListUpdated(for tags: [Tag]) {
        self.tags = tags
        noteView.setAttributedTags(for: tags)
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

extension EditNoteViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        var textToSearch = "\(textField.text!)"
        if string != "" {
            textToSearch += "\(string)"
        } else {
            let endIndex = textToSearch.index(
                textToSearch.startIndex, offsetBy: textToSearch.count-1)
            textToSearch = String(textToSearch[..<endIndex])
        }
        guard let objects = fetchedResultsController.fetchedObjects else {
            return true
        }
        if textToSearch == "" {
            categoriesDatasource = objects
            noteView.categoryCollection.reloadData()
            return true
        }
        categoriesDatasource = []
        for index in 0..<objects.count {
            if let categoryName = objects[index].name {
                if categoryName.lowercased().starts(
                    with: textToSearch.lowercased()) {
                    categoriesDatasource?.append(objects[index])
                }
            }
        }
        noteView.categoryCollection.reloadData()
        return true
    }
    
}

extension EditNoteViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        guard let categorySection =
            categoriesDatasource else { return 0 }
        return categorySection.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoryItemCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryItemCell.identifier,
            for: indexPath) as! CategoryItemCell
        
        guard let datasource = categoriesDatasource,
            let categoryName = datasource[indexPath.item].name else {
            categoryItemCell.itemName.attributedText =
                .smallTextAttributed(forText: "Undefined")
            return categoryItemCell
        }
        
        categoryItemCell.itemName.attributedText =
            .smallTextAttributed(forText: categoryName)
        let colorId = datasource[indexPath.item].colorId
        categoryItemCell.layer.borderColor =
            CategoryColor.getColor(id: Int(colorId)).cgColor
        categoryItemCell.backgroundColor = .white
        
        return categoryItemCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        guard let datasource = categoriesDatasource else { return }
        
        if let unselectIndexPath = selectedCategory?.indexPath {
            if unselectIndexPath.item < datasource.count {
                // Unselect previous selection
                let cellToUnselect = collectionView.cellForItem(
                    at: unselectIndexPath) as! CategoryItemCell
                cellToUnselect.backgroundColor = .clear
            } else {
                selectedCategory = nil
            }
        }
        // Update the new selected category cell
        let itemSelected = SelectedCategory(
            category: datasource[indexPath.item],
            indexPath: indexPath)
        selectedCategory = itemSelected
        let categoryCell = collectionView.cellForItem(
            at: indexPath) as! CategoryItemCell
        categoryCell.backgroundColor =
            CategoryColor.getColor(id: Int(datasource[indexPath.item].colorId))
    }
}

extension EditNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let datasource = categoriesDatasource,
            let categoryName = datasource[indexPath.item].name else {
            return CGSize(width: 80, height: 40)
        }
        let textAttributed =
            NSAttributedString.smallTextAttributed(forText: categoryName)
        let offset: CGFloat = 8.0
        return CGSize(
            width: textAttributed.size().width + offset,
            height: textAttributed.size().height + offset)
    }
}
