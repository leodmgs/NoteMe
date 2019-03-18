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
        setupNotificationsHandling()
        fetchNotes()
    }
    
    private func setupNotificationsHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(managedObjectContextDidChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil)
    }
    
    @objc private func managedObjectContextDidChange() {
        self.fetchNotes()
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
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: #keyPath(Note.updatedAt), ascending: false)]
        coreDataBroker.managedObjectContext.performAndWait {
            do {
                let notes = try fetchRequest.execute()
                self.notes = notes
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
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

