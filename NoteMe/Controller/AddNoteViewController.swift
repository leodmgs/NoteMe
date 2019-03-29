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

struct SelectedCategory {
    var category: Category
    var indexPath: IndexPath
}

class AddNoteViewController: UIViewController {
    
    /*
     The instance of the managed object context is required in order to create
     a Note object that will be managed by its context. The reference for this
     object needs to be assigned before calling this class.
     */
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
    
    let noteView: NoteView = {
        let view = NoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var categoriesDatasource: [Category]?
    var selectedCategory: SelectedCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryDatasource()
        noteView.contentsTextView.delegate = self
        noteView.searchCategoryTextField.delegate = self
        noteView.categoryCollection.delegate = self
        noteView.categoryCollection.dataSource = self
        noteView.categoryCollection.register(
            CategoryItemCell.self,
            forCellWithReuseIdentifier: CategoryItemCell.identifier)
        setupView()
    }
    
    private func loadCategoryDatasource() {
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
        if let selected = selectedCategory {
            note.category = selected.category
        }
        note.contents = noteView.contentsTextView.text
    }
    
    func tagAttributed(for text: String) -> NSAttributedString {
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)])
        return attributedText
    }
    
}

extension AddNoteViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var textToSearch = "\(textField.text!)"
        if string != "" {
            textToSearch += "\(string)"
        } else {
            let endIndex = textToSearch.index(textToSearch.startIndex, offsetBy: textToSearch.count-1)
            textToSearch = String(textToSearch[..<endIndex])
        }
        guard let objects = fetchedResultsController.fetchedObjects else { return true }
        if textToSearch == "" {
            categoriesDatasource = objects
            noteView.categoryCollection.reloadData()
            return true
        }
        categoriesDatasource = []
        for index in 0..<objects.count {
            if let categoryName = objects[index].name {
                if categoryName.lowercased().starts(with: textToSearch.lowercased()) {
                    categoriesDatasource?.append(objects[index])
                }
            }
        }
        noteView.categoryCollection.reloadData()
        return true
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

extension AddNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        guard let categories = categoriesDatasource else { return 0 }
        return categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoryItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.identifier, for: indexPath) as! CategoryItemCell
        
        guard let datasource = categoriesDatasource,
            let name = datasource[indexPath.item].name else {
            categoryItemCell.itemName.attributedText = tagAttributed(for: "Undefined")
            return categoryItemCell
        }
        categoryItemCell.itemName.attributedText = tagAttributed(for: name)
        let colorId = datasource[indexPath.item].colorId
        categoryItemCell.layer.borderColor =
            CategoryColor.getColor(id: Int(colorId)).cgColor
        categoryItemCell.backgroundColor = .clear
        return categoryItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let datasource = categoriesDatasource else { return }
        if let unselectIndexPath = selectedCategory?.indexPath {
            if unselectIndexPath.item < datasource.count {
                // Unselect previous selection
                let cellToUnselect = collectionView.cellForItem(at: unselectIndexPath) as! CategoryItemCell
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
        let categoryCell = collectionView.cellForItem(at: indexPath) as! CategoryItemCell
        categoryCell.backgroundColor =
            CategoryColor.getColor(id: Int(datasource[indexPath.item].colorId))
    }

}

extension AddNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let object = self.fetchedResultsController.object(at: indexPath)
        guard let datasource = categoriesDatasource,
            let text = datasource[indexPath.item].name else {
            // FIXME: default size
            return CGSize(width: 80, height: 40)
        }
        let textAttributed = tagAttributed(for: text)
        let offset: CGFloat = 8.0
        return CGSize(
            width: textAttributed.size().width + offset,
            height: textAttributed.size().height + offset)
    }
}


extension AddNoteViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
    }
}
