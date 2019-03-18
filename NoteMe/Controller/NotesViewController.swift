//
//  ViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/7/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    var notes: [Note]? {
        didSet {
            notesDidChange()
        }
    }
    
    var coreDataBroker: CoreDataBroker = {
        let coreData = CoreDataBroker(modelName: "NoteMe")
        return coreData
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: #keyPath(Note.updatedAt), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataBroker.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var notesView: UINotesView = {
        let view = UINotesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.notesTableView.delegate = self
        view.notesTableView.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        fetchNotes()
    }
    
    private func setupNavigationBar() {
        guard let navController = navigationController else { return }
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.topItem?.title = "NoteMe"
        let addNoteButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(onAddNoteTapped))
        navigationItem.rightBarButtonItem = addNoteButtonItem
    }
    
    @objc private func onAddNoteTapped() {
        guard let navController = navigationController else { return }
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.managedObjectContext = coreDataBroker.managedObjectContext
        navController.pushViewController(addNoteViewController, animated: true)
    }

    private func setupView() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
        view.addSubview(notesView)
        activateRegularConstraints()
    }
    
    private func notesDidChange() {
        DispatchQueue.main.async {
            self.notesView.notesTableView.reloadData()
        }
    }
    
    func onNoteSelected(_ note: Note) {
        guard let navController = navigationController else { return }
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.note = note
        navController.pushViewController(editNoteViewController, animated: true)
    }
    
    func configure(_ cell: NoteCell, at indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = note.title
    }
    
    private func fetchNotes() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Execute Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            notesView.topAnchor.constraint(equalTo: view.topAnchor),
            notesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

}

extension NotesViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesView.notesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesView.notesTableView.endUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                notesView.notesTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                notesView.notesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath,
                let cell = notesView.notesTableView.cellForRow(at: indexPath)
                    as? NoteCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                notesView.notesTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                notesView.notesTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}
